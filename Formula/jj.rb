class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/martinvonz/jj"
  url "https://github.com/martinvonz/jj/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "85e73cde738a2b92aeb253ee3a29f113589c19ad11d4244a14e2d0ca5fbfb3c7"
  license "Apache-2.0"
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "58dda95cf54e78ea0d21e1672048dca382bf04b03ad96ed2c7e54e4781e3df7f"
    sha256 cellar: :any,                 arm64_monterey: "f35af76fd39dca3bd71d0a0fe0e393c2c95f9c9d6555f8f23fee1cdbcea8a698"
    sha256 cellar: :any,                 arm64_big_sur:  "d957be7c9363c8986797b1830aca5923534dacad7ba84a774c8e225aaa5337f9"
    sha256 cellar: :any,                 ventura:        "1f46dc6823240920cc589a7b802054e75fa7887e7c1d1a313656726581eaf99c"
    sha256 cellar: :any,                 monterey:       "352cd6e9a1ff12beb3201c625dcfff8e4e000a5c6ea3ae569f2b4a93f838a579"
    sha256 cellar: :any,                 big_sur:        "65a096a8bf89082043e4505535fe6193eac37c9555e26c3d0233ebd85d22f4e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3b06731b08b3ac4d6ee5e50dd97775fcbfe06bed4f2a7cca7692a09baf34c7f"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--no-default-features", "--bin", "jj", *std_cargo_args
    generate_completions_from_executable(bin/"jj", "debug", "completion", shell_parameter_format: :flag)
  end

  test do
    system bin/"jj", "init", "--git"
    assert_predicate testpath/".jj", :exist?
  end
end
