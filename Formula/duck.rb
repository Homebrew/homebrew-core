class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.6.0.28133.tar.gz"
  sha256 "6491c93d1816027dc12aa155a95342b8fd50ada6d48790a752d5b0570b1e0f3c"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "66158ea16b94cfa85f582a40a4fb7f8bd91690ce05c1ace320eb049de058efb3" => :high_sierra
    sha256 "ed08bc63c5536a1646b872bf35e15491d92c47a4c2208e7e9a2ed401a2a15791" => :sierra
    sha256 "e202a3b2b457402616a85386641b5f6e800981798e440ab39556576806bc3a00" => :el_capitan
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
    system "#{bin}/duck", "--download", "https://ftp.gnu.org/gnu/wget/wget-1.19.4.tar.gz", testpath/"test"
    assert_equal (testpath/"test").sha256, "93fb96b0f48a20ff5be0d9d9d3c4a986b469cb853131f9d5fe4cc9cecbc8b5b5"
  end
end
