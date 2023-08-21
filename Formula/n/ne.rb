class Ne < Formula
  desc "Text editor based on the POSIX standard"
  homepage "https://github.com/vigna/ne"
  url "https://github.com/vigna/ne/archive/3.3.2.tar.gz"
  sha256 "9b8b757db22bd8cb783cf063f514143a8c325e5c321af31901e0f76e77455417"
  license "GPL-3.0"
  head "https://github.com/vigna/ne.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "118365512d7c91463595795cf8ac3f5bb8c0ced42fdb8c4e52321c6858ec61e0"
    sha256 arm64_monterey: "041e27ae4a7fabc0e61e89365c63916bf2e4be0ab0e1da78b4a2c0e9043a9ba8"
    sha256 arm64_big_sur:  "53b99d998ae08a5608c2c3f049306619cb80b11a1d44ddc243d32378357df5ad"
    sha256 ventura:        "ce2f35fd2873e3ee85470a4c2e19eb68d5e03060b70eca9973b5fa5e3741be8d"
    sha256 monterey:       "60cc57ed07026f7a2b67f32b011e6c6f5b2105e2d0ceeff772d7052746797153"
    sha256 big_sur:        "bec8bb3b21f20213c3f4d26f6dc03d5c7d25b269d22ac460b5fe810343506d14"
    sha256 x86_64_linux:   "ed309053b95ca315b71c123dbf7b3b51fbb1e734e99e8ac0e1747295772ce644"
  end

  depends_on "texinfo" => :build

  uses_from_macos "ncurses"

  on_linux do
    # The version of `env` in CI is too old, so we need to use brewed coreutils.
    depends_on "coreutils" => :build
  end

  # Fixes info2src.pl [364]: $commands{SYNTAX}->{"abbr"} undefined.
  # https://github.com/vigna/ne/issues/109#issuecomment-1355675699
  # Remove in next release
  patch do
    url "https://github.com/vigna/ne/commit/90ae494711a06944f0027224cf6a4b4a812d1e95.patch?full_index=1"
    sha256 "6ea1dbe3a133e2af896640a8cfe4e3e2f412e5fa521de181781cfa8c640d796a"
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
