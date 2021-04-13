class Kubeprod < Formula
  desc "Installer for the Bitnami Kubernetes Production Runtime (BKPR)"
  homepage "https://kubeprod.io"
  url "https://github.com/bitnami/kube-prod-runtime/archive/v1.7.0.tar.gz"
  sha256 "8bc41467511e69b53e29257ffd588fbaca6a904f3bec04493a1e7eb7048ea67d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a65d7ea7bfd9b2d2fbd6606440ea83c6b0003fbbdccaa47bb50bac7499d842df"
    sha256 cellar: :any_skip_relocation, big_sur:       "ea49a918a879287e50d1b4161113efd395bd0c80afc0394f6453f9d70af9e60d"
    sha256 cellar: :any_skip_relocation, catalina:      "72b78c5b8393d7fe37d9b1ec1e53f32a34162f4a6379ddd2250bbe5680c53d3e"
    sha256 cellar: :any_skip_relocation, mojave:        "75fc89249f53f9b8fe8e09bf3970c11ddc2aaa417f49735c2ac79b0d468dca3e"
    sha256 cellar: :any_skip_relocation, high_sierra:   "bf0f97d8da14fd61c43cf1844eb4899f81073719c233aaaa0856f971e0dfc048"
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
