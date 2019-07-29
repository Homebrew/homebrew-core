class Jmxtrans < Formula
  desc "Tool to connect to JVMs and query their attributes"
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/jmxtrans-parent-270.tar.gz"
  sha256 "7261eb083e0ad927d69bc48bd190a0c1c1a340f20812514bd0ee59e4b25f8fd0"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "8ba9f5d54de8350421d72dfbbaa821e89d8707e5177a7156ce55f87e89befcfd" => :mojave
    sha256 "a443805c63b0b51d4b13dfa2cc92b0d3f04ec2bcca3cffedb27ccd1e8d124fad" => :high_sierra
    sha256 "3b9479ac46dc39a6f0a69bf43c5469abb31f33de6f51159ba6754a52d4127d7c" => :sierra
    sha256 "3a21472f2c7858af301650a533be93ff9d4589e8497a7ada7dfe9165a4b00987" => :el_capitan
  end

  depends_on "maven" => :build
  depends_on :java => "1.8"

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
