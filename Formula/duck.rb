class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.3.1.27228.tar.gz"
  sha256 "deb7ee00e2b4d349f25e33973b9d4b0033048ced645034616c1156d3356e3aa8"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "353903922babf82a7847b206a133d33801e11b11bf5336bc558984a60643884e" => :high_sierra
    sha256 "d43d56f86b4dbcf2c0b4980c73f19f75d23fcb0099124a3f1ccb0937d6ce2077" => :sierra
    sha256 "af8a90604bc0472af3651293aae3fee3ea83d44d1f06e439fbe82e802f4618a9" => :el_capitan
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
    system "#{bin}/duck", "--download", Formula["when"].stable.url, testpath/"test"
    (testpath/"test").verify_checksum Formula["when"].stable.checksum
  end
end
