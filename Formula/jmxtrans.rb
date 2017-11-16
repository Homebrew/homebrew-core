class Jmxtrans < Formula
  desc "Tool to connect to JVMs and query their attributes"
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/jmxtrans-parent-268.tar.gz"
  sha256 "711b90e9687b4429abce3dcc3856b3e7d2b5aa4452457bfe71a5f7768a140536"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "b1f1c4aa08900547ca121fc96ccdf32649b48fd72b409264a47f15b20e3932dc" => :high_sierra
    sha256 "d18b73d89cb462d4343289fd57ac22c0aff14ee08e15d16728b868f9200917e5" => :sierra
    sha256 "0a1fec59601c7e7c9e4ced90193c1dcccee4c7a7e10ed7c647d3115f0afd54a2" => :el_capitan
    sha256 "9f3aa7d2469df6cfb27e52d66052693fd1b0a73732d3b10b16c08b788109dcb3" => :yosemite
  end

  depends_on :java => "1.8"
  depends_on "maven" => :build

  def install
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp

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

    (bin/"jmxtrans").write_env_script libexec/"jmxtrans.sh", Language::Java.java_home_env("1.8")
  end

  test do
    output = shell_output("#{bin}/jmxtrans status", 3).chomp
    assert_equal "jmxtrans is not running.", output
  end
end
