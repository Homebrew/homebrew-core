class Chezscheme < Formula
  desc "Chez Scheme"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/archive/v9.5.tar.gz"
  sha256 "a1d9f93bd8a683ea3d8f2f1b4880f85ea40bf9a482ee6b84cb0fe0ab6148a98c"

  bottle do
    sha256 "7599610cda8eeda8b10921d4e8092f939b02fa32810201fea5df0bcb7b0623d4" => :mojave
    sha256 "6d2cbd144310fa2c0fcd8aed0e673ed5b301bea98351122b98aad497ca474db1" => :high_sierra
    sha256 "e3a63252006520a340f1a208506cca2c4210e08865b322bfd9be7cf83babbeaf" => :sierra
    sha256 "684d39c61e2d1279106dba378d1d1d9de0b1a10a7668a73d9c59f44e6a450f1c" => :el_capitan
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
    (testpath/"hello.ss").write <<~EOS
      (display "Hello, World!") (newline)
    EOS

    expected = <<~EOS
      Hello, World!
    EOS

    assert_equal expected, shell_output("#{bin}/chez --script hello.ss")
  end
end
