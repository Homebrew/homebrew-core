class Egctl < Formula
  desc "Command-line utility for operating Envoy Gateway"
  homepage "https://gateway.envoyproxy.io/"
  url "https://github.com/envoyproxy/gateway/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "e8872afd89ef78edb2eaba6ac1c3457d46b5aabb7edb7fe5a6db60c438d8d39c"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/gateway.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44350a2743f9485aca37f00acbb84849c50ccd3ddac15439bb51e35c4048b1bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16bd304b3c755e2f9445ee0ad5b345307934cd30ca80cd0fa89fb5c5d5fb63b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c748eda53f828b948df57b50b505458ad9a715c5bb416441f91aa80f131de99"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e46461abbf42fa0ea0fa1d9c36e38f7b9abc5918a8cbc04ae50f72f82a0996a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c004e48cd27ff28f693a9dbecb10c3962d8dc81684d017010958509c3dbf7d2"
    sha256 cellar: :any,                 x86_64_linux:  "a868ce38ebc51b90fa18a6ea5c2f531f11d52056c2872282d9b7eb5a8b8c9eac"
  end

  depends_on "go" => :build

  on_linux do
    on_intel do
      depends_on "btrfs-progs" => :build
    end
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/envoyproxy/gateway/internal/cmd/version.envoyGatewayVersion=#{version}
      -X github.com/envoyproxy/gateway/internal/cmd/version.gitCommitID=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/egctl"

    generate_completions_from_executable(bin/"egctl", shell_parameter_format: :cobra)
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/egctl version --remote=false").strip

    (testpath/"input.yaml").write <<~YAML
      apiVersion: gateway.networking.k8s.io/v1
      kind: GatewayClass
      metadata:
        name: eg
      spec:
        controllerName: gateway.envoyproxy.io/gatewayclass-controller
      ---
      apiVersion: gateway.networking.k8s.io/v1
      kind: Gateway
      metadata:
        name: eg
        namespace: default
      spec:
        gatewayClassName: eg
        listeners:
          - name: http
            protocol: HTTP
            port: 80
      ---
      apiVersion: v1
      kind: Namespace
      metadata:
        name: default
      ---
      apiVersion: v1
      kind: Service
      metadata:
        name: backend
        namespace: default
        labels:
          app: backend
          service: backend
      spec:
        clusterIP: "1.1.1.1"
        type: ClusterIP
        ports:
          - name: http
            port: 3000
            targetPort: 3000
            protocol: TCP
        selector:
          app: backend
      ---
      apiVersion: gateway.networking.k8s.io/v1
      kind: HTTPRoute
      metadata:
        name: backend
        namespace: default
      spec:
        parentRefs:
          - name: eg
        hostnames:
          - "www.example.com"
        rules:
          - backendRefs:
              - group: ""
                kind: Service
                name: backend
                port: 3000
                weight: 1
            matches:
              - path:
                  type: PathPrefix
                  value: /
    YAML

    expected = <<~YAML
      xds:
        default/eg:
          '@type': type.googleapis.com/envoy.admin.v3.RoutesConfigDump
          dynamicRouteConfigs:
          - routeConfig:
              '@type': type.googleapis.com/envoy.config.route.v3.RouteConfiguration
              ignorePortInHostMatching: true
              name: default/eg/http
              virtualHosts:
              - domains:
                - www.example.com
                metadata:
                  filterMetadata:
                    envoy-gateway:
                      resources:
                      - kind: Gateway
                        name: eg
                        namespace: default
                        sectionName: http
                name: default/eg/http/www_example_com
                routes:
                - match:
                    prefix: /
                  metadata:
                    filterMetadata:
                      envoy-gateway:
                        resources:
                        - kind: HTTPRoute
                          name: backend
                          namespace: default
                  name: httproute/default/backend/rule/0/match/0/www_example_com
                  route:
                    cluster: httproute/default/backend/rule/0
                    upgradeConfigs:
                    - upgradeType: websocket

    YAML

    output = shell_output("#{bin}/egctl x translate --from gateway-api --to xds -t route -f #{testpath}/input.yaml")
    assert_equal expected, output
  end
end
