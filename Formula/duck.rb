class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.7.1.28683.tar.gz"
  sha256 "567ecd08e6a26ec2024d00274311c2a2b0110d3ac4fdf83ac0ddc7c6bfcffb53"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "548f752fa9433a4cfc3ea78fed9801f52d2787cae12440c024670ec0a24d87f3" => :high_sierra
    sha256 "a70b8d1136924d3dd2e1f25bfd56ff3c7c95592672ebbe9519dc58ddf35dcb2c" => :sierra
    sha256 "80b4b52328b8f24954405228638dd8e08d0673298699885c82af789035c35e54" => :el_capitan
  end

  depends_on :java => ["1.8+", :build]
  depends_on :xcode => :build
  depends_on "ant" => :build
  depends_on "maven" => :build

  def install
    revision = version.to_s.rpartition(".").last
    system "mvn", "-DskipTests", "-Dgit.commitsCount=#{revision}",
                  "--projects", "cli/osx", "--also-make", "verify"
    libexec.install Dir["cli/osx/target/duck.bundle/*"]
    bin.install_symlink "#{libexec}/Contents/MacOS/duck" => "duck"
  end

  test do
    system "#{bin}/duck", "--download", "https://ftp.gnu.org/gnu/wget/wget-1.19.4.tar.gz", testpath/"test"
    assert_equal (testpath/"test").sha256, "93fb96b0f48a20ff5be0d9d9d3c4a986b469cb853131f9d5fe4cc9cecbc8b5b5"
  end
end
