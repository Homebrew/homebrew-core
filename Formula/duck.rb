class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.6.0.28133.tar.gz"
  sha256 "6491c93d1816027dc12aa155a95342b8fd50ada6d48790a752d5b0570b1e0f3c"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "de962f22beeb1946ad4ba46a82774758dd08291b524432f53b793b5421f1e55b" => :high_sierra
    sha256 "dd74a2adac3560108c30c976bbbb9bcb9cbbaf24e782c8ccbfee041eb66b1540" => :sierra
    sha256 "2a2678ccc0a1e3c96591e46684e1ddaa06e704e9c269a2736ccdd9d773913950" => :el_capitan
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
