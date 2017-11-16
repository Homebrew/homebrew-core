class Jmxtrans < Formula
  desc "Tool to connect to JVMs and query their attributes"
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/jmxtrans-parent-268.tar.gz"
  sha256 "711b90e9687b4429abce3dcc3856b3e7d2b5aa4452457bfe71a5f7768a140536"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "9e98df7b2c006cc8577f48df30edf45b55b3b7bfdc57a9ab2c48b7812e062225" => :high_sierra
    sha256 "9ff4256cc60b8fa306c6d7ff9fc30a91a97d5d84b39c58282425011b1d35f805" => :sierra
    sha256 "58f20dce4df7b7c669c531ba5ee8697ea9a87702d3abde4bde27db527b086496" => :el_capitan
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
