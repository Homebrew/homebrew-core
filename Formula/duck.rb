class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.3.3.27375.tar.gz"
  sha256 "e25540faaf84506b9911d7200bfa99b6eee9203139b2a835362c8eea0db124c1"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "131c8d2a59e8176f3fc9abef06366ddda55c893e60bd7f4ca97a4434a7ee52aa" => :high_sierra
    sha256 "3b3cac5dde6ba1978af9c6cc0026013b59defd0a00598ec4b56016831e848bf2" => :sierra
    sha256 "e5e94747327035e7e16384f54a865a9c022bfed19b369c4cbadc732620c63b31" => :el_capitan
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
