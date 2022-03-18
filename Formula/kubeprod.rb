class Kubeprod < Formula
  desc "Installer for the Bitnami Kubernetes Production Runtime (BKPR)"
  homepage "https://kubeprod.io"
  url "https://github.com/bitnami/kube-prod-runtime/archive/v1.8.0.tar.gz"
  sha256 "cc2fbda4c115d164afcaaabbbef4b5824b9b09b6df95d9cce021aee50c2ad2c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "397d87c63d6eb199e49a2d695d3f16619f0fef0ffdf905c6378d241d1259b4c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cf8f68102f72c4f3dc4398baa40bed174c9383fe70d6c092416a2413b59fea7"
    sha256 cellar: :any_skip_relocation, monterey:       "da4dad9205b38cf15027cb688595bdc75b1b6fa653edea53061e151fae192987"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5bcbbcfb672ba55f4cc8ff037265ad5609637c680a3913ed70902fcd942446f"
    sha256 cellar: :any_skip_relocation, catalina:       "d93e5540cc7b2b7a479b69613c9aab0e9809a838cb1241f20650c01c9c37fc56"
    sha256 cellar: :any_skip_relocation, mojave:         "8eacc39ef3927f4405137db71864e0db6d0b27f97d5c5499f00d5d60ed58eebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d33e013a915ab5b777bcdf0d11476c55905896c29cf168c76558bf66e6753403"
  end

  deprecate! date: "2022-03-18", because: :repo_archived

  depends_on "go@1.17" => :build

  def install
    cd "kubeprod" do
      system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "-mod=vendor"
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
