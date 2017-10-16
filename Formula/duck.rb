class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.2.9.26659.tar.gz"
  sha256 "8b1ba2a11ac9a8982fa7e7d3f5d2e75c76326e9a481824a39c0e4a7fb885febb"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "490e8dbdbb152c9088136c916a954bf41c7371a3c09898b8093c5530bf73928a" => :high_sierra
    sha256 "308ace43350b6551b04a66d28cc31004571ef1d38dfecdbacb587a14ba5690ca" => :sierra
    sha256 "2d1d22eabaaf586010d2c9e0bc0b9521e04029384eefd4b210ce7fc43b0c598e" => :el_capitan
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
