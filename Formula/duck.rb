class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.2.10.26754.tar.gz"
  sha256 "45b4281a788673f838825064a339f2d2f07356f05a76a011aaa2e3e54a267430"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "67f2bbb583d5b968326f8ee49ae8ca39481b64669f9e1e7bb8cd954ed4db5293" => :high_sierra
    sha256 "31a333620e425cf7fea21f636e5387bb44cffa9639ef1379fa123c720a0070ae" => :sierra
    sha256 "ca0a5a36481a47b5ef3651327b16dcf05cd530496db0f84bda7e5c16177548cd" => :el_capitan
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
