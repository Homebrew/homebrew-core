class Ngs < Formula
  desc "Powerful programming language and shell designed specifically for Ops"
  homepage "https://ngs-lang.org/"
  url "https://github.com/ngs-lang/ngs/archive/v0.2.12.tar.gz"
  sha256 "bd3f3b7cca4a36150405f26bb9bcc2fb41d0149388d3051472f159072485f962"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/ngs-lang/ngs.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1c9af117b7fc71c4c6560fbe5c7715a623581f096f43d5fcebd65c710e3a8179"
    sha256 cellar: :any,                 arm64_big_sur:  "f8c08e896c845d4363dbde2dd0cd92febc5565e998f3961bd36e68b228e136e5"
    sha256 cellar: :any,                 monterey:       "dc7f134f50532d5c101cc314b93a4ab701ff3c822e82ef3d7ede25a2c5d676fa"
    sha256 cellar: :any,                 big_sur:        "d2c8b66be9a77490146d581f004fb6bbd733ce8f8f9bd9a7ae17e237bd62d7c6"
    sha256 cellar: :any,                 catalina:       "6c8834ddb9de895c1fb8dd13ff41858c2b1dd78e7def77eeefe51076e4508941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0600e1fd9cacb9ebccb20ec1d9385eb91f831c87c330e8269e810960275a37f"
  end

  depends_on "cmake" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "gnu-sed"
  depends_on "json-c"
  depends_on "pcre"
  depends_on "peg"

  uses_from_macos "libffi"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    share.install prefix/"man"
  end

  test do
    assert_match "Hello World!", shell_output("#{bin}/ngs -e 'echo(\"Hello World!\")'")
  end
end
