class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://docs.ignite.com/"
  url "https://github.com/ignite/cli/archive/refs/tags/v29.1.0.tar.gz"
  sha256 "74bb7766fb7612b6e465a39259ac26a173f9fb9f0a26dc52dcaa6ce2696685fb"
  license "Apache-2.0"
  head "https://github.com/ignite/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4c33ccf933df428f3ece6227762b8df0d9ae5fb8b0e02b01f728aac9a2542bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5ff6941bbdc0e588a2dee30b2f36f885c387a6dbcebf84b4dcc134f082aeaa9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a342602ba95128eb6ffcc6cb4218bcf9656dadaf26b3d1b1bfbdd0e1fc42ed8"
    sha256 cellar: :any_skip_relocation, sonoma:        "07d637221c99acbb5dfb63373319dba8f7fc6417844748e0bf2ae456cd82e028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfb611470010c88f97bdee973f507db603e08a909a2be79cb109b67a94a6db5f"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin/"ignite"), "./ignite/cmd/ignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars"
    sleep 2
    sleep 2 if OS.mac? && Hardware::CPU.intel?
    assert_path_exists testpath/"mars/go.mod"
  end
end
