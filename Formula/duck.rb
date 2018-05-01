class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.5.0.27854.tar.gz"
  sha256 "a989dcc6b3d86cd488bd95f4c5dc0c182ce8d24b4ed27904c0bf38328826f4cd"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "4bb7ee32d3147c03768a215841be6f7572a4c37aa01d7eadc392ec0cf5123472" => :high_sierra
    sha256 "d32ca8d4a666c6b1f662795b00af566370a5e5f4efbbcd4831d27d8801df0bd6" => :sierra
    sha256 "372b74084bf2ecf1458f6be4a344be3b8f1aba86ff6fcd55a497748ebc885a27" => :el_capitan
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
