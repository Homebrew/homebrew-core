class Neix < Formula
  desc "RSS/Atom feed reader for your terminal"
  homepage "https://github.com/tomschwarz/neix"
  url "https://github.com/tomschwarz/neix/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "23d39f0695fe73a737725c8a1266e02a6a173dcaf0a649ba30db02bc3e54a42f"
  license "GPL-3.0-only"

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    system "cmake", ".", *std_cmake_args, "-DENABLE-TESTS=ON" # Enable the unit tests
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    installed_version = "\e[0;33m[neix]\e[0m Installed version: v0.1.5\n"
    assert_match installed_version, shell_output("#{bin}/neix -v")
  end
end
