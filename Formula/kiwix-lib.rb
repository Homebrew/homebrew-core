class KiwixLib < Formula
  desc "Common code base for all Kiwix ports"
  homepage "https://github.com/kiwix/kiwix-lib"
  url "https://github.com/kiwix/kiwix-lib/archive/9.3.1.tar.gz"
  sha256 "b36500af589797e220d0a5fc551047f016c8914ac2d4b04666daef977aa0a4ce"
  license "GPL-3.0+"

  depends_on "libkainjow-mustache" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "aria2"
  depends_on "icu4c"
  depends_on "libmicrohttpd"
  depends_on "libzim"
  depends_on "pugixml"

  uses_from_macos "curl"

  def install
    inreplace "meson.build", "/usr/include/kainjow", "/usr/local/include/kainjow"
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test kiwix-lib`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
