class Jvmtop < Formula
  desc "Console application for monitoring all running JVMs on a machine"
  homepage "https://github.com/patric-r/jvmtop"
  url "https://github.com/patric-r/jvmtop/releases/download/0.8.0/jvmtop-0.8.0.tar.gz"
  sha256 "f9de8159240b400a51b196520b4c4f0ddbcaa8e587fab1f0a59be8a00dc128c4"

  bottle :unneeded

  depends_on :java

  def install
    rm Dir["*.bat"]
    mv "jvmtop.sh", "jvmtop"
    chmod 0755, "jvmtop"

    libexec.install Dir["*"]
    (bin/"jvmtop").write_env_script(libexec/"jvmtop", Language::Java.java_home_env)
  end
end
