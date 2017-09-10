class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.2.6.26405.tar.gz"
  sha256 "5dded926e589867562b37ac7d5c4fc2bedb6631c619d1b3d9fb4764ea44c1122"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "cc5c048af97c37b23f61bd4e92568328d46a9186c68278d40bc6a90f02c717e9" => :sierra
    sha256 "07305aea47f9a5fb77feb99ad89cf25a173c443272c8f647ccd8a672a0bedfff" => :el_capitan
    sha256 "d1366ea2f1f5a0ef3443eef3840ca5b42591c5d51c201acd1ea636811dfa62ea" => :yosemite
  end

  depends_on :java => ["1.8+", :build]
  depends_on :xcode => :build
  depends_on "ant" => :build
  depends_on "maven" => :build

  def install
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
