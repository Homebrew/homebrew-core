class Kubeprod < Formula
  desc "Installer for the Bitnami Kubernetes Production Runtime (BKPR)"
  homepage "https://kubeprod.io"
  url "https://github.com/bitnami/kube-prod-runtime/archive/v1.1.0.tar.gz"
  sha256 "fb238bd46fe5177c976640746b3ff51c3961388a4e10edd9581880e0ab670e22"

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

    authzDomain = "castle-black.com"
    project = "white-walkers"
    oauthClientId = "jon-snow"
    oauthClientSecret = "king-of-the-north"
    contactEmail = "jon@castle-black.com"

    ENV["KUBECONFIG"] = testpath/"kube-config"
    system "#{bin}/kubeprod", "install", "gke",
              "--authz-domain", "#{authzDomain}",
              "--project", "#{project}",
              "--oauth-client-id", "#{oauthClientId}",
              "--oauth-client-secret", "#{oauthClientSecret}",
              "--email", "#{contactEmail}",
              "--only-generate"

    assert File.file? "kubeprod-autogen.json"
    assert_match "\"authz_domain\": \"#{authzDomain}\"", File.read("kubeprod-autogen.json")
    assert_match "\"client_id\": \"#{oauthClientId}\"", File.read("kubeprod-autogen.json")
    assert_match "\"client_secret\": \"#{oauthClientSecret}\"", File.read("kubeprod-autogen.json")
    assert_match "\"contactEmail\": \"#{contactEmail}\"", File.read("kubeprod-autogen.json")

    assert File.file? "kubeprod-manifest.jsonnet"
    assert_match "https://releases.kubeprod.io/files/v#{version}/manifests/platforms/gke.jsonnet", File.read("kubeprod-manifest.jsonnet")
  end
end
