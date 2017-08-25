class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.2.3.26209.tar.gz"
  sha256 "089ba5ae693d7b4cd87a5d5be3b683ec4245668436e57142a1f2ab5422604706"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "2485d396ed52f0a78caaf0c2c444b2a5da1f5d0a9f9ac0229afad9978e6ddb13" => :sierra
    sha256 "82db5c022f77260b457258c7dc4cf0cf1c83d7a4ae398844d111d6eb17c73bef" => :el_capitan
    sha256 "a2c01024cc1c58a46e901a7f215a48c017e1b30ce570653773e7439800c89a39" => :yosemite
  end

  depends_on :java => ["1.8+", :build]
  depends_on :xcode => :build
  depends_on "ant" => :build
  depends_on "maven" => :build

  def install
    ENV.java_cache
    revision = version.to_s.rpartition(".").last
    system "mvn", "-DskipTests", "-Dgit.commitsCount=#{revision}", "--projects", "cli/osx", "--also-make", "verify"
    libexec.install Dir["cli/osx/target/duck.bundle/*"]
    bin.install_symlink "#{libexec}/Contents/MacOS/duck" => "duck"
  end

  test do
    system "#{bin}/duck", "--download", Formula["libmagic"].stable.url, testpath/"test"
    (testpath/"test").verify_checksum Formula["libmagic"].stable.checksum
  end
end
