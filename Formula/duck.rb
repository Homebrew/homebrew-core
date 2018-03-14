class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.4.4.27722.tar.gz"
  sha256 "097f3cb983e10080e0660d6ff9b2f4c44d135b048474af0c24b1b0f1806f1c05"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "75ab35638f01ac012a9e6e49f3b74b2940d0a102bf935896bea6c9a3e7605cb6" => :high_sierra
    sha256 "f763c28c678876785f073507f35e49e4bd8a8cd6f9dda7b4ac56daeba9494c31" => :sierra
    sha256 "baa7c7f7065c07b7b5f4915e7e9758ecf78ab0f17a0a3050b7eb82d1d9f80d93" => :el_capitan
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
