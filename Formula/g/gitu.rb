class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "4749822d6561690c37ba45c56b81582979798ae93acd704b850b834ca6b73c02"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "06d49a280dfddfcc51786f40c3d27069f3082b05d08f3c70da99b94cf254c08f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "54321464d3a8e92f7ce38a7d7737d3db6929fcbbc111fb88d06c39b6b2a1e1e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "abc65c5200a9cad96cc568a62a703c70eaf239df1c38d5b7c1e3289aabccffef"
    sha256 cellar: :any,                 arm64_linux:       "dac73a67266f487369725cb417dd04390fbf3466f54147eac3c73bf958c17a29"
    sha256 cellar: :any,                 x86_64_linux:      "f1fe6c155fcf821d3a8ad71925861efb14c43725e4122334a81001ee56a6bd83"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"gitu", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    # `--print` renders one frame without setting up the terminal, which hangs without a TTY
    assert_match "No .git found in the current directory", shell_output("#{bin}/gitu --print 2>&1", 1)

    system "git", "init", "--initial-branch=main"
    (testpath/"README.md").write "hello"
    assert_match "README.md", shell_output("#{bin}/gitu --print")
  end
end
