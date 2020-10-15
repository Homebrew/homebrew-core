class Chezscheme < Formula
  desc "Implementation of the Chez Scheme language"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/archive/v9.5.4.tar.gz"
  sha256 "258a4b5284bb13ac6e8b56acf89a7ab9e8726a90cc57ea1cd71c5da442323840"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec01053507184a4f7974281be6484d44005ad3ee67b0ca76e87c18dda329050e" => :catalina
    sha256 "2e483db1013a2045e245b81f869c0bbc348998e73463bcb225199c929416ffa2" => :mojave
    sha256 "062b486d9b8fc1d81716361b5f0267a12599dea779f3cf37e5879c33b41bf568" => :high_sierra
  end

  depends_on x11: :build
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
