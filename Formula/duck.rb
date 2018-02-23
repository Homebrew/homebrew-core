class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.4.1.27633.tar.gz"
  sha256 "3e754165cfd96200c5901b291cfb0e8aff5a956fc8d38a6c32e0091444524f52"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "056fccc0b194bf09a354b9e7bdfe8fbcba3ee7dc7a53f9f48b17d64e96a238e7" => :high_sierra
    sha256 "13f0f8a1321cf5108f597cc4a81a4b0c89404669883b9b42fc0d72ad2eb55861" => :sierra
    sha256 "202bdded1ddb8319916f06811a7952247b35b82e3ba0976e1dc624e6ae191506" => :el_capitan
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
