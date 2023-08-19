class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/martinvonz/jj"
  url "https://github.com/martinvonz/jj/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "636661cb4eb8248ae98c443bd72464de9b6a150175388559ccb321f2461011f1"
  license "Apache-2.0"
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "94d818bdaf9b483fcc2bbb082d36f78932ebfe99a133f6e412f041f01906a5c1"
    sha256 cellar: :any,                 arm64_monterey: "bd01f7149aa7ad6904953c0a4d513c529299457c9fcc6deba7d8c324e621a393"
    sha256 cellar: :any,                 arm64_big_sur:  "09708cb6bf10a7d1dbdcfcdfe541ebfd5ac758b5e90da636ea25a8e2c8fec840"
    sha256 cellar: :any,                 ventura:        "0698a6fbe84ed51f3376d984c3355447758051df3f19ba447eb17d2a80475e14"
    sha256 cellar: :any,                 monterey:       "234f106919e24c8ce55565063e7ad625b06f0b367a71fab6010aca1a9d5a3cf8"
    sha256 cellar: :any,                 big_sur:        "0ac86653132e231a64867af7f26c532c6379e51f9bfab137fe10660c9bde82b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "219dfbf9af292642059302d469c333268253589bd8947d387004225754d6a232"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--no-default-features", "--bin", "jj", *std_cargo_args
    generate_completions_from_executable(bin/"jj", "util", "completion", shell_parameter_format: :flag)
    (man1/"jj.1").write Utils.safe_popen_read(bin/"jj", "util", "mangen")
  end

  test do
    system bin/"jj", "init", "--git"
    assert_predicate testpath/".jj", :exist?
  end
end
