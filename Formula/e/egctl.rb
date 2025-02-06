class Egctl < Formula
  desc "Command-line utility for operating Envoy Gateway"
  homepage "https://gateway.envoyproxy.io/"
  url "https://github.com/envoyproxy/gateway/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "9ab6a574670b12ac535e1cbe00d478aba5bb714ac77b64c8e9fcbde056f0202b"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/gateway.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4a2187f5d34071e42cf26d39fa242547554dc1578afd5537e293c7ca60eab53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3a7d524a72349ac573da85326dce733c3768145244e8cf0d25fe2943dbe5ea1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d072dbc45ee85b4be351f919564f6aecc0131d049f03f22794a32b1245ed4abf"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e01ada218a171ee584b07c076122fc01ce4310f7ef6fea1acb248a148c0fd5d"
    sha256 cellar: :any_skip_relocation, ventura:       "f7c8d086124cb9ef66d07eb96c0588768c0f229c2cfe883e4ab1722685c710e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac4cec51a734f0d932f2c35319a2ea0b8208d5c184a6d6aaddee595c44c70c11"
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

    generate_completions_from_executable(bin/"egctl", "completion")
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
