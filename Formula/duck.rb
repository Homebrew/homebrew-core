class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.3.3.27375.tar.gz"
  sha256 "e25540faaf84506b9911d7200bfa99b6eee9203139b2a835362c8eea0db124c1"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "9a7676e85f869acdf6f687f4fd7e7b73ede5778fa094018c07658c1eb830126c" => :high_sierra
    sha256 "fe6cb1c868c8c5078f66ec06994e5f4264ee0d2c26579afcea42094f8724ffc8" => :sierra
    sha256 "e9e02fa90b0868fb85194ece28e0ac461c63937f3d223b22525580635ba1c9ee" => :el_capitan
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
