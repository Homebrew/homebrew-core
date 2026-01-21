class Egctl < Formula
  desc "Command-line utility for operating Envoy Gateway"
  homepage "https://gateway.envoyproxy.io/"
  url "https://github.com/envoyproxy/gateway/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "749f1498fe4addfb0302c46e6ab55ae277dcb446cf73242eacb7d4f6d46e1ba0"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/gateway.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb3dd4d81bbe0794d801dd93b51dc690dc40b1db93d99aeda2611352645723a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc07f17c4d1295bd62870edcad2f025ae90dd60278bf921375c6734b61719aa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b029bfc1dd01b9c903a50cf32aecf577626b8b7ce173c259610e7aebe1d7832"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1a5bba1944cbd91062f2539f913bedd267840a4b511e18c690c58176758583e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aec71e4bf69f9a5c144446e67981603c977229a60d979a85e22152fcdeb366ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e195c474b62a0715eed1e1cfebf7b113e93f03fbd750b47e3785275cee75152"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "btrfs-progs"
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

    expected = <<~EOS
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

    EOS

    output = shell_output("#{bin}/egctl x translate --from gateway-api --to xds -t route -f #{testpath}/input.yaml")
    assert_equal expected, output
  end
end
