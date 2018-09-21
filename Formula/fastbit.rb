class Fastbit < Formula
  desc "Open-source data processing library in NoSQL spirit"
  homepage "https://sdm.lbl.gov/fastbit/"
  url "https://code.lbl.gov/frs/download.php/file/426/fastbit-2.0.3.tar.gz"
  sha256 "1ddb16d33d869894f8d8cd745cd3198974aabebca68fa2b83eb44d22339466ec"

  bottle do
    cellar :any
    sha256 "fa55894d8decb82e8731d1af1541aa17569cf34691c1b23272525e5cd6ea66d3" => :mojave
    sha256 "10b30f7face5fec9926fcc84b1acda1e11edbaf6438ddde8d819a431766adc98" => :high_sierra
    sha256 "688a35ebf6323a6323181db1c8fd048c00031b8c3d89f49b2d81586576723541" => :sierra
    sha256 "8488bbb85691e3181243fb0ad2afb84715c684204551e5064bff9846d18be82e" => :el_capitan
  end

  depends_on :java

  conflicts_with "iniparser", :because => "Both install `include/dictionary.h`"

  # Fix compilation with Xcode 9, reported by email on 2018-03-13
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/fe9d4e5/fastbit/xcode9.patch"
    sha256 "e1198caf262a125d2216d70cfec80ebe98d122760ffa5d99d34fc33646445390"
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    libexec.install lib/"fastbitjni.jar"
    bin.write_jar_script libexec/"fastbitjni.jar", "fastbitjni"
  end

  test do
    assert_equal prefix.to_s,
                 shell_output("#{bin}/fastbit-config --prefix").chomp
    (testpath/"test.csv").write <<~EOS
      Potter,Harry
      Granger,Hermione
      Weasley,Ron
    EOS
    system bin/"ardea", "-d", testpath,
           "-m", "a:t,b:t", "-t", testpath/"test.csv"
  end
end
