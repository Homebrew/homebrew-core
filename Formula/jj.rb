class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/martinvonz/jj"
  url "https://github.com/martinvonz/jj/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "bea5980f6857370b93b396df03401f38f928400ac42ba8e757c86f34098956ce"
  license "Apache-2.0"
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "49b13ddc6b71b2a3b3af034f21ada755bc6641e77603ff1ce1e4be8d234c3267"
    sha256 cellar: :any,                 arm64_big_sur:  "28c721c735ed357a81294663634c69e534f507dc9900ef2d9dd233ab1dc76176"
    sha256 cellar: :any,                 monterey:       "b0c31564e5d186f4a1e91f44e4873ccb82869fffe5fb32bb8b4ceb7f0e7957df"
    sha256 cellar: :any,                 big_sur:        "3ba780ca5517ffd39f456fcdea388a0a3a5b6905e97a8c2b870ac5c36aef7954"
    sha256 cellar: :any,                 catalina:       "20c70c59024b28ab1bab70a602bfbc0d4820f148a2b35f64eb6a8882a035a8b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4973fd915d33a58f03d7686f90744f56b6aa7be884407d9b799f9501b45fd702"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--no-default-features", "--bin", "jj", *std_cargo_args
  end

  test do
    system bin/"jj", "init", "--git"
    assert_predicate testpath/".jj", :exist?
  end
end
