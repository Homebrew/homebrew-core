class Jmxtrans < Formula
  desc "Tool to connect to JVMs and query their attributes"
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/jmxtrans-parent-269.tar.gz"
  sha256 "4b95ebd0c6546100bcabde3f77d9134e3573df88b5b596d671ce8f4f1f24b241"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "4e82041319c8299661a237debdc596c3ffdf83ca0aff2fdeeac3e6574a378a2b" => :high_sierra
    sha256 "70f7e73aef1dae8cac06869bbc0262ef33870752436b60a6d2d604828c337e6d" => :sierra
    sha256 "74201a074840c2a450d336effdd73d57dbc9fab9a45fec4686459d2553995ec2" => :el_capitan
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
