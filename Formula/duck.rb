class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.2.0.25806.tar.gz"
  sha256 "271230bc6158312efd28f06cbe1a9d2581aa068aad3c85aafd1c90f427c8ecf1"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "41959a52c038b95de0eaeab866a3bdb9851a2dc0860507beffd053c3f8b98180" => :sierra
    sha256 "3d948cef37326f3cb0bc95f03fb60aec27e0ef8a5f2526a6aa3f0017d45fb0ec" => :el_capitan
    sha256 "90e77ae74e37df631cbf1bcfd6607ed6d0cbe371ac8beafc71fe1cd8842b6347" => :yosemite
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
