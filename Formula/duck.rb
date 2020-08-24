class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-7.5.2.33336.tar.gz"
  sha256 "f084aca8b58069ccfeb62752f47daeff80f54991478189b274c06c7cfe0fa338"
  license "GPL-3.0-only"
  revision 1
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    cellar :any
    sha256 "4a3f03c8964145c8ada23b2fea80c2ceb7fdbe671aa9573512d5c1ce99fda420" => :catalina
    sha256 "57772f1f20740ab1fdb0290899abf42d44860a90c0bbceecedb3658a08170b34" => :mojave
    sha256 "1b572ce5af2ea5d74d25f364329d9b1ec6e9e3a118c21222d1538c918732ac6e" => :high_sierra
  end

  depends_on "ant" => :build
  depends_on "maven" => :build
  depends_on xcode: :build

  def install
    xcconfig = buildpath/"Overrides.xcconfig"
    xcconfig.write <<~EOS
      OTHER_LDFLAGS = -headerpad_max_install_names
    EOS
    ENV["XCODE_XCCONFIG_FILE"] = xcconfig
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
