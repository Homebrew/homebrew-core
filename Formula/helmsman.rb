class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    :tag      => "v3.1.0",
    :revision => "43eb54f956423a82bf9f67cfefb9e58271d04dd9"

  bottle do
    cellar :any_skip_relocation
    sha256 "10f47665a24258159c96c6ecbe9b681c0ff49b3acc1079ff85ed1ca767559cc4" => :catalina
    sha256 "919815309cf66bb927d695c70d27eb515e6338e09b3123fd8cf74ca231256a0d" => :mojave
    sha256 "8c51f7a713ff93442c2608090b38c4a3d98587f0aa058df69650b38ae3567bf7" => :high_sierra
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
