class Egctl < Formula
  desc "Command-line utility for operating Envoy Gateway"
  homepage "https://gateway.envoyproxy.io/"
  url "https://github.com/envoyproxy/gateway/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "546dade7aaabb8a853eb2c9101929c3098abbf67d9525ecd69507d33769a5a4a"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/gateway.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ff6c5ee453791185f179d3ca054b1633e89adf09fd347a50517adef8a726080"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6d246b0c715dce6a100f9a7665d34c5363b0985cfa6e4ae122e6f997e581b39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "264636055a3f2cfbe61f99bc5ac7862d823c0d609a9c1a2c923fe15dee15cd43"
    sha256 cellar: :any_skip_relocation, sonoma:        "72962639567b7ed30b6d3e461d32d43e1b85c89d21062cee4a0339411aaca797"
    sha256 cellar: :any_skip_relocation, ventura:       "a52c5950b21853961ba3c44f5e66a8e1465b40aba687149b0002a641dda68bb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36e97acec1fbb23f7613d6978f4463ea8df68fd9c54cab7b114a32a4f0dc906d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b68e77662b82f265ee6ed45c77bc2a55008661ad02d4334a09a7af6b51558c0"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "btrfs-progs"
  end

  # bump purego to build against go 1.24.3, upstream pr ref, https://github.com/envoyproxy/gateway/pull/6075
  patch do
    url "https://github.com/envoyproxy/gateway/commit/8aaee41dde53411a03d71c0808d4ed502455195d.patch?full_index=1"
    sha256 "37fac3a17bc8876e07df799d6dd7a614411c9fceb63988654c1e3d18c6b28a45"
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
