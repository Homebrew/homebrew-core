class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-7.4.1.33065.tar.gz"
  sha256 "b535188cf37946c350f090aa493d5240ee1ef2b077d673613cd5655c337ef912"
  license "GPL-3.0"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    cellar :any
    sha256 "2f9ff25196e1011d13062e297921f4aa58b64402c301dd54eb21f4756ee00e06" => :catalina
    sha256 "f0c845346eafbf26f371753aa6a6e2fe21e7bd5c4ef8d4fbcf918e3ebc075688" => :mojave
    sha256 "81014a37b9adbd268a782af0b6e6b71e4e241e4fcb92d57e74aec6671aa48869" => :high_sierra
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
