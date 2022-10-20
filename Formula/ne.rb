class Ne < Formula
  desc "Text editor based on the POSIX standard"
  homepage "https://github.com/vigna/ne"
  url "https://github.com/vigna/ne/archive/3.3.2.tar.gz"
  sha256 "9b8b757db22bd8cb783cf063f514143a8c325e5c321af31901e0f76e77455417"
  license "GPL-3.0"
  head "https://github.com/vigna/ne.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "3f7e0ae2691ee9f8c1560c44ad34b3180e137dcb318e4ef4d05137d6c531ab33"
    sha256 arm64_big_sur:  "fae2a8975de41ecbfb9ec22845831377360ed407edfff9f15e09c6c57cda2cf1"
    sha256 monterey:       "b0651ff75f326f1710e2235564dc5d1089248b7e0d7cf2b5377ddf6d1b343e70"
    sha256 big_sur:        "48cc19c9a971d63ec35530e71930277f033e4f931bf613153ff1f9a095654158"
    sha256 catalina:       "249c14869150874534d6a865be9d147fa87b0987d69192ae73e0b4a9644db163"
    sha256 x86_64_linux:   "60b786b997a8f01b66c83eeb13c76c5f6c0d2005122539f7f271b58c205a569f"
  end

  depends_on "texinfo" => :build

  uses_from_macos "ncurses"

  on_linux do
    # The version of `env` in CI is too old, so we need to use brewed coreutils.
    depends_on "coreutils" => :build
  end

  def install
    # Use newer env on Linux that supports -S option.
    unless OS.mac?
      inreplace "version.pl",
                "/usr/bin/env",
                Formula["coreutils"].libexec/"gnubin/env"
    end
    ENV.deparallelize
    cd "src" do
      system "make"
    end
    system "make", "build", "PREFIX=#{prefix}", "install"
  end

  test do
    require "pty"

    ENV["TERM"] = "xterm"
    document = testpath/"test.txt"
    macros = testpath/"macros"
    document.write <<~EOS
      This is a test document.
    EOS
    macros.write <<~EOS
      GotoLine 2
      InsertString line 2
      InsertLine
      Exit
    EOS
    PTY.spawn(bin/"ne", "--macro", macros, document) do |_r, _w, pid|
      sleep 1
      Process.kill "KILL", pid
    end
    assert_equal <<~EOS, document.read
      This is a test document.
      line 2
    EOS
  end
end
