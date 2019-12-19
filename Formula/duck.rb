class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-7.2.2.32045.tar.gz"
  sha256 "691409699811a954a65e0d2552e5de045c3eec5eac63366addac3bcec68b8e0a"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    cellar :any
    sha256 "9db2a0c760798d954055aff33372a3d4ed44cf1947bb14698ecfe017265db268" => :catalina
    sha256 "481eb41f877fae8aace54a9df2ef0459e2205f4eeb66af1d8e1bd32da7a5f3ea" => :mojave
    sha256 "ae7d708e9692d5ed3771e6b21292c36c3dc7f3a3d86eac37eb14e9c95383cf0c" => :high_sierra
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
