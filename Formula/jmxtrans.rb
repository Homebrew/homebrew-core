class Jmxtrans < Formula
  desc "Tool to connect to JVMs and query their attributes"
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/jmxtrans-parent-266.tar.gz"
  sha256 "5181a755b8af7f6bc94e0f7d2a40c34eca089524899154c5ff1d290ad0bd430e"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "9c4b29567b2eed6109163f7150503ae2ac0e31f7e3c67bdc4bf4bcfcabf7c880" => :sierra
    sha256 "7537ed47b0b8cfb5617a10e8d67cecadf414c36e08495c348d71d06b2a04607a" => :el_capitan
    sha256 "627f5aa44573c5a9081b16f3ef770daf9b36c192f10a17eec4b45351c1a0a82d" => :yosemite
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
