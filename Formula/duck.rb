class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.4.4.27722.tar.gz"
  sha256 "097f3cb983e10080e0660d6ff9b2f4c44d135b048474af0c24b1b0f1806f1c05"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "b6c346e117e400798bc1b1002ee764530f2d279619df2410730731993a3314cf" => :high_sierra
    sha256 "ae102c755dcc3ee79fb1e3bc1179caaf329894f3fb67f324b1ab8176f1b05b55" => :sierra
    sha256 "a833e9cc89c3785fda774e76774ff6dfe334731f4653fc06ccd8dfab5c99e6f9" => :el_capitan
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
