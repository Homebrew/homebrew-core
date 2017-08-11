class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.2.2.26027.tar.gz"
  sha256 "bb66759c9b73d8f8806457b643356fcd39c11da4bce23e0d66df157430ea3a56"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "2ab8011c2d4d87b167ca2ec0c6288a055741bc19cf71ecfde83cd05549f91570" => :sierra
    sha256 "d310d991238f7cb5b21a212bbcd3c4400aac1e77ead5d218bc9dc7110f48c4e8" => :el_capitan
    sha256 "f149df8b541522bc13be302bd004936ca128f5c0aa182b62a11e00b482a4e55e" => :yosemite
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
