class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.7.1.28683.tar.gz"
  sha256 "567ecd08e6a26ec2024d00274311c2a2b0110d3ac4fdf83ac0ddc7c6bfcffb53"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "7d510f90f81c1bc6f4a29bd662e50e44aa9e8de9dc4f086fc6c277bf0b224f06" => :mojave
    sha256 "e10ce4d54a2b9dfe0f0c1b3bcd7c053d3dc4cde1363e454b1b681e3d33f8acb7" => :high_sierra
    sha256 "0ed5c77ec0381165ef7b8cf7d45c3a473343c69cce4073784cd8ae0ab8c4cdad" => :sierra
    sha256 "470f922732207586a55c84141aa438d367613b96edcbb3043fe1c1e20a333244" => :el_capitan
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
