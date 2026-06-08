class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.20.4.tar.gz"
  sha256 "64bedf53df302eb9bb99e84c2f9ca39d30b7b5ba54927e998f786149ab3ec471"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f76e8918f8b417449aafa2e3e450438bbb20071de373bad7740ff5d19303e37d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7173c0f87cc84bc7aaa9fdc44dd8e83f3914eb5ba6f59a4b6f96b3ddfaac69f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4705d7e97349455c1d8949abbe9aa97d45eb9e8dc8f796cb880f67a40e2d1306"
    sha256 cellar: :any_skip_relocation, sonoma:        "611fa980331817605129d5c7a329d8a2ec00e5f909ee649423ded4b44fe17a0d"
    sha256 cellar: :any,                 arm64_linux:   "1867030a2713b02efbc0fca8c0f5fa3aed7522b0aee535ef6fb86a567343e6f5"
    sha256 cellar: :any,                 x86_64_linux:  "078a80ec06bd0cdd5c5cfaa7e42d287169a4d5aa053e72322b488c816f65a0ea"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args(features: "binjulialauncher")

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin/"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
