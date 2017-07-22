class Jmxtrans < Formula
  desc "Tool to connect to JVMs and query their attributes"
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/jmxtrans-parent-266.tar.gz"
  sha256 "5181a755b8af7f6bc94e0f7d2a40c34eca089524899154c5ff1d290ad0bd430e"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "dae3e96e825cbbe93217a8abd6ff9c83522a7ec37bf08c54110b6d9bf742cd73" => :sierra
    sha256 "bfb01344216bed04b029ba0252f4ee74a378081de7939c08cc79be5d64d5acd4" => :el_capitan
    sha256 "794a71d17def85a0d11db4bf5e1eddb5508564d0e84e76f1ecb00e3ee5d07279" => :yosemite
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
