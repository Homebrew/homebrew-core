class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.3.4.27404.tar.gz"
  sha256 "7ccbbc64f7d84cd4ef31386092169f3417acf21f4ab7c1cccd1db2abe6cde206"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "8af273462cc03088ef05df5c949bec5ff128d6be206ed82a95c011d804ccef5f" => :high_sierra
    sha256 "b7f700d1d7d6fd74cc3e99013d56192688c16940e837711e5ff998b4040bde9f" => :sierra
    sha256 "7bc70dc8f5caf3d36be178995ab9e747995335c38a90d431b9c7dbb1f39bb233" => :el_capitan
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
