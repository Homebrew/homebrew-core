class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-7.4.0.32960.tar.gz"
  sha256 "a32d9bee22ab9ccd9bdfb4457041d5e00726f871b6bb11760a2ba52805e4b7e8"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    cellar :any
    sha256 "30f62bc3f7a9290d345a7cca1fd6a66f71d3c209e60427e900f98b355b10c383" => :catalina
    sha256 "d822e53151ca1832ebb4a3c4a5993ecf32fd084040c23c6ecb03edbc995ee48a" => :mojave
    sha256 "c34f2ea8580b1f928bf98913914b4c29b32c5b36c04ec1d6edd2ef6625db5840" => :high_sierra
  end

  depends_on "ant" => :build
  depends_on :java => ["1.8", :build]
  depends_on "maven" => :build
  depends_on :xcode => :build

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
