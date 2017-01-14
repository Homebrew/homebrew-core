class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "http://gosu-lang.org/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.14.3.tar.gz"
  sha256 "f67a579ef72449194b7b583e0de01e5e56fc33d0d5b0df23b482d5391ea9ae48"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd62c8051ae3caf01f9e20c57a5aa9e7137070b8da0ecb9c9f7058ac4e03c64b" => :sierra
    sha256 "2ce150af49a97706cd58dd55296acef0c3177333499c80db93be4e8d441e3b6d" => :el_capitan
    sha256 "b55774ff7bcac2690e182019d90e8cc6bdfcde6fd241269a5fc2b69daf2e5e4e" => :yosemite
  end

  depends_on :java => "1.8+"
  depends_on "maven" => :build

  skip_clean "libexec/ext"

  def install
    ENV.java_cache

    system "mvn", "package"
    libexec.install Dir["gosu/target/gosu-#{version}-full/gosu-#{version}/*"]
    (libexec/"ext").mkpath
    bin.install_symlink libexec/"bin/gosu"
  end

  test do
    (testpath/"test.gsp").write 'print ("burp")'
    assert_equal "burp", shell_output("#{bin}/gosu test.gsp").chomp
  end
end
