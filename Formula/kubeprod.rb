class Kubeprod < Formula
  desc "Installer for the Bitnami Kubernetes Production Runtime (BKPR)"
  homepage "https://kubeprod.io"
  url "https://github.com/bitnami/kube-prod-runtime/archive/v1.8.0.tar.gz"
  sha256 "cc2fbda4c115d164afcaaabbbef4b5824b9b09b6df95d9cce021aee50c2ad2c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7177cd43435b95e4622ecf59817b80775ebef3b71f08dea0cdee41c92c269ca4"
    sha256 cellar: :any_skip_relocation, big_sur:       "0ab0d7506871863c10df7d97b61bcf5cc85feaf89f57e2ba5c7b37bf9b6de7c8"
    sha256 cellar: :any_skip_relocation, catalina:      "bd0172c95cc57541ae8caf8d0eea41324e65b969fabd917bcdf4c7f45ebeac55"
    sha256 cellar: :any_skip_relocation, mojave:        "87236a079210371961cc4ade279577b79ccd569c3f8668f5cb0fa91fcdbec4d3"
  end

  depends_on "go" => :build

  def install
    cd "kubeprod" do
      system "go", "build", *std_go_args, "-ldflags", "-X main.version=v#{version}", "-mod=vendor"
    end
  end

  test do
    version_output = shell_output("#{bin}/kubeprod version")
    assert_match "Installer version: v#{version}", version_output

    (testpath/"kube-config").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: test
          server: http://127.0.0.1:8080
        name: test
      contexts:
      - context:
          cluster: test
          user: test
        name: test
      current-context: test
      kind: Config
      preferences: {}
      users:
      - name: test
        user:
          token: test
    EOS

    authz_domain = "castle-black.com"
    project = "white-walkers"
    oauth_client_id = "jon-snow"
    oauth_client_secret = "king-of-the-north"
    contact_email = "jon@castle-black.com"

    ENV["KUBECONFIG"] = testpath/"kube-config"
    system "#{bin}/kubeprod", "install", "gke",
                              "--authz-domain", authz_domain,
                              "--project", project,
                              "--oauth-client-id", oauth_client_id,
                              "--oauth-client-secret", oauth_client_secret,
                              "--email", contact_email,
                              "--only-generate"

    json = File.read("kubeprod-autogen.json")
    assert_match "\"authz_domain\": \"#{authz_domain}\"", json
    assert_match "\"client_id\": \"#{oauth_client_id}\"", json
    assert_match "\"client_secret\": \"#{oauth_client_secret}\"", json
    assert_match "\"contactEmail\": \"#{contact_email}\"", json

    jsonnet = File.read("kubeprod-manifest.jsonnet")
    assert_match "https://releases.kubeprod.io/files/v#{version}/manifests/platforms/gke.jsonnet", jsonnet
  end
end
