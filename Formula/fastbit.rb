class Fastbit < Formula
  desc "Open-source data processing library in NoSQL spirit"
  homepage "https://sdm.lbl.gov/fastbit/"
  url "https://code.lbl.gov/frs/download.php/file/426/fastbit-2.0.3.tar.gz"
  sha256 "1ddb16d33d869894f8d8cd745cd3198974aabebca68fa2b83eb44d22339466ec"
  revision 1

  bottle do
    cellar :any
    sha256 "ce5bd1a75d14f7f11b2bdcb9cf63aebc63f3c722dd4a39380e50d2c8489b2347" => :big_sur
    sha256 "09dc75c92fa358be93b38636c4e747d0768af669e396b07854975684bdba8494" => :arm64_big_sur
    sha256 "31e723c0610621033859357ab2a6dc373cf955847ab5c3dcf32696d260fa0de3" => :catalina
    sha256 "0f9a32fe10c3e5c6e2826009f247bc55064ad5612dcda9724cda203c8b18e00e" => :mojave
    sha256 "a7d7330e664e04191fe183050b588e4d3ad13aa101553f8f6965deb708c96d72" => :high_sierra
  end

  depends_on "openjdk"

  conflicts_with "iniparser", because: "both install `include/dictionary.h`"

  # Fix compilation with Xcode 9, reported by email on 2018-03-13
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/fe9d4e5/fastbit/xcode9.patch"
    sha256 "e1198caf262a125d2216d70cfec80ebe98d122760ffa5d99d34fc33646445390"
  end

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-java=#{Formula["openjdk"].opt_prefix}"
    system "make", "install"
    libexec.install lib/"fastbitjni.jar"
    (bin/"fastbitjni").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -jar '#{libexec}/fastbitjni.jar' "$@"
    EOS
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
