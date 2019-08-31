class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.40.0.tar.xz"
  sha256 "a760a3520d9f3a16a4ed73cefaabdbd86125bec73c6fa056ca3f0a4be8478dd6"
  revision 3
  head "https://github.com/gammu/gammu.git"

  bottle do
    sha256 "5b6ddc65c6e2f792bfd3169068e1f17fc7dd786c0b60a9cd4990eba2413c9eaa" => :mojave
    sha256 "42c0f1378d0ee8dd838cfcd4fcc4d08692972e5454801ee625902ed5b5a0f7cf" => :high_sierra
    sha256 "95f1e27545040d0c55df797688369f6d20a2af34d3341739153fdab23cf5417e" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "openssl@1.1"

  def install
    # Disable opportunistic linking against Postgres
    inreplace "CMakeLists.txt", "macro_optional_find_package (Postgres)", ""
    mkdir "build" do
      system "cmake", "..", "-DBASH_COMPLETION_COMPLETIONSDIR:PATH=#{bash_completion}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"gammu", "--help"
  end
end
