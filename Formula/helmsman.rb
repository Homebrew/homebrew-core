class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.7.0",
      revision: "995800328cf48b13ccf19f3d459767db269e3823"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9a6258eb8445c3d17fe77edb23a6383f2a0fbacc6b99a1e39f8d405c128deebf"
    sha256 cellar: :any_skip_relocation, big_sur:       "74f57835d0b1e6a750a67359b9383bb563b72ae0a518fbb4f2c0a4a5926080f8"
    sha256 cellar: :any_skip_relocation, catalina:      "09db53e32b1aea835d0f8437afbb265f1bcd6708363fc85e0b7ae96c04e98201"
    sha256 cellar: :any_skip_relocation, mojave:        "b73cc8e84ff9bdfd64893e0878b30047f0e98054a335e6e3f6aeea6adf16a56c"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}", "./cmd/helmsman"
    pkgshare.install "examples/example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/helmsman version")

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff not found", output
  end
end
