class Chezscheme < Formula
  desc "Chez Scheme"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/archive/v9.4.tar.gz"
  sha256 "9f4e6fe737300878c3c9ca6ed09ed97fc2edbf40e4cf37bd61f48a27f5adf952"

  bottle do
    rebuild 1
    sha256 "96ced10b5fdddf2c8489cf9eaf1f20a85ebee73561340c34fcdf8ede5c859ec9" => :sierra
    sha256 "0bd0cb29369b4b029351095fad544573241c791d700424cc937f33cabd034d32" => :el_capitan
    sha256 "3a4f0f3c1a15208a03e6518b6a3e483f9340801a8121fcb637c458992d422d9b" => :yosemite
  end

  depends_on :x11 => :build

  def install
    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    # Reported 20 Feb 2017 https://github.com/cisco/ChezScheme/issues/146
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
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
    (testpath/"hello.ss").write <<-EOS.undent
      (display "Hello, World!") (newline)
    EOS

    expected = <<-EOS.undent
      Hello, World!
    EOS

    assert_equal expected, shell_output("#{bin}/chez --script hello.ss")
  end
end
