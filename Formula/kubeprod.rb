class Kubeprod < Formula
  desc "Installer for the Bitnami Kubernetes Production Runtime (BKPR)"
  homepage "https://kubeprod.io"
  url "https://github.com/bitnami/kube-prod-runtime/archive/v1.6.1.tar.gz"
  sha256 "fdf5b82ea274033488af2c2c6057507e601366f61b2f888b33bee767e4000d77"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "72b78c5b8393d7fe37d9b1ec1e53f32a34162f4a6379ddd2250bbe5680c53d3e" => :catalina
    sha256 "75fc89249f53f9b8fe8e09bf3970c11ddc2aaa417f49735c2ac79b0d468dca3e" => :mojave
    sha256 "bf0f97d8da14fd61c43cf1844eb4899f81073719c233aaaa0856f971e0dfc048" => :high_sierra
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
