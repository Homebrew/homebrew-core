class Chezscheme < Formula
  desc "Chez Scheme"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/archive/v9.5.2.tar.gz"
  sha256 "3a370fdf2ffd67d6a0ccbb993dfab1cbaf4a0a97983c869cfaab40528c33c48b"

  bottle do
    cellar :any_skip_relocation
    sha256 "22a69bfdc7cc44396429124104397dc5377b4e1b184064c8adec33bd0ff6203d" => :mojave
    sha256 "3ce7b28cde766fe8b6f4c517182b5c21f38371108839712ac85c94f3fcd4a07a" => :high_sierra
    sha256 "e26d93d7b1c4bfefa3238809c81cfe6b30a3d0fd57e716bb712a1258cb05d5f9" => :sierra
  end

  depends_on :x11 => :build
  uses_from_macos "ncurses"

  def install
    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    # Reported 20 Feb 2017 https://github.com/cisco/ChezScheme/issues/146
    if MacOS.version == "10.11" && MacOS::Xcode.version >= "8.0"
      inreplace "c/stats.c" do |s|
        s.gsub! "CLOCK_MONOTONIC", "UNDEFINED_GIBBERISH"
        s.gsub! "CLOCK_PROCESS_CPUTIME_ID", "UNDEFINED_GIBBERISH"
        s.gsub! "CLOCK_REALTIME", "UNDEFINED_GIBBERISH"
        s.gsub! "CLOCK_THREAD_CPUTIME_ID", "UNDEFINED_GIBBERISH"
      end
    end

    system "./configure",
              "--installprefix=#{prefix}",
              "--threads",
              "--installschemename=chez"
    system "make", "install"
  end

  test do
    (testpath/"hello.ss").write <<~EOS
      (display "Hello, World!") (newline)
    EOS

    expected = <<~EOS
      Hello, World!
    EOS

    assert_equal expected, shell_output("#{bin}/chez --script hello.ss")
  end
end
