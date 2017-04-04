class Jmxtrans < Formula
  desc "Tool to connect to JVMs and query their attributes"
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/jmxtrans-parent-264.tar.gz"
  sha256 "006d723ee1830df474b0e786e310dbe3317c6b4b9649f30fff9d64d314e59cba"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "817bf2d67ecdcb90b51e93c3b2745c6b8ac58b93a6a62dfb16de5ec934e27b6e" => :sierra
    sha256 "2589a9e18a647b5c997d01a3d4ffbd9fc96e3f2550d8bb1ceb9e42ea2ed1e8e7" => :el_capitan
    sha256 "cdf54fa018d319a0db40b8439722bd62b70d6f7c0ab38a327715918935278ff7" => :yosemite
  end

  depends_on :java => "1.6+"
  depends_on "maven" => :build

  def install
    ENV.java_cache

    system "mvn", "package", "-DskipTests=true",
                             "-Dmaven.javadoc.skip=true",
                             "-Dcobertura.skip=true"

    cd "jmxtrans" do
      vers = Formula["jmxtrans"].version.to_s.split("-").last
      inreplace "jmxtrans.sh", "lib/jmxtrans-all.jar",
                               libexec/"target/jmxtrans-#{vers}-all.jar"
      chmod 0755, "jmxtrans.sh"
      libexec.install %w[jmxtrans.sh target]
      pkgshare.install %w[bin example.json src tools vagrant]
      doc.install Dir["doc/*"]
    end

    bin.install_symlink libexec/"jmxtrans.sh" => "jmxtrans"
  end

  test do
    output = shell_output("#{bin}/jmxtrans status", 3).chomp
    assert_equal "jmxtrans is not running.", output
  end
end
