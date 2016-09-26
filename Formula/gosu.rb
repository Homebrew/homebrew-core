class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "http://gosu-lang.org/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.14.1.tar.gz"
  sha256 "b553e15d366080baf99a33df388b4cc529fb69418a449d580755ae793a82bee8"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "09a63006ce328260b4da609f107d42a26ae99dd71d03d283478f66d2442a91a8" => :sierra
    sha256 "a3d5e276aa6e72b4ee6e24d2f2fb587d13b8d26220cce497ee3a677f12572643" => :el_capitan
    sha256 "1527fb0e159801e828fbfcae07f2cc10fc4c187b828701ee02c7c3c27ad62157" => :yosemite
    sha256 "89b53c0e632bfcc9a5385e0ac583c026fe39a2ed91a971233e2d45d235196584" => :mavericks
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
