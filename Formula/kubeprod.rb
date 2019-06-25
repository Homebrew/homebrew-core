class Kubeprod < Formula
  desc "Installer for the Bitnami Kubernetes Production Runtime (BKPR)"
  homepage "https://kubeprod.io"
  url "https://github.com/bitnami/kube-prod-runtime/archive/v1.3.3.tar.gz"
  sha256 "36220f51795295eddb6a022b136d2a595967e291add1b0218e2ee98beb942224"

  bottle do
    cellar :any_skip_relocation
    sha256 "21242ba2efa4d3deabd6795719d8e8ef46717bc9ef6b706dc163c9351a8129db" => :mojave
    sha256 "6399d65b8a65725ce805449ece2bf0a723e81a6462248602564d3bb5f4f79be4" => :high_sierra
    sha256 "7b15c0ec8c87f8dcb3f38e62b59c3be380754ee0beea01ee5f1005d9099d79d8" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TARGETS"] = "darwin/amd64"
    dir = buildpath/"src/github.com/bitnami/kube-prod-runtime"
    dir.install buildpath.children

    cd dir do
      system "make", "-C", "kubeprod", "release", "VERSION=v#{version}"
      bin.install "kubeprod/_dist/darwin-amd64/bkpr-v#{version}/kubeprod"
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
