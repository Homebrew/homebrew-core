class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.6.3",
      revision: "5583540acbd38487c014205af3f64eeedfc28147"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2a77c0fc09e21576284ecf696fd5292003593947052ec60b54586ab1b20c65f" => :big_sur
    sha256 "659eded9fe7d41d58ec7db54e4054d980cabbb340af420f12f31234a6b2905df" => :catalina
    sha256 "52af46e0d35a06e85079da7b4f3b877226fbc3da3cd8baf1d9b5ac4b80e8bcc7" => :mojave
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      "-trimpath", "-o", bin/"helmsman", "cmd/helmsman/main.go"
    prefix.install_metafiles
    pkgshare.install "examples/example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/helmsman version")

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff plugin is not installed", output
  end
end
