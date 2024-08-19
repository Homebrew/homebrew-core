class Jvmtop < Formula
  desc "Console application for monitoring all running JVMs on a machine"
  homepage "https://github.com/patric-r/jvmtop"
  url "https://github.com/patric-r/jvmtop/releases/download/0.8.0/jvmtop-0.8.0.tar.gz"
  sha256 "f9de8159240b400a51b196520b4c4f0ddbcaa8e587fab1f0a59be8a00dc128c4"
  license "GPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f8d349142f3bcc5b90e06245a32942918f8664ddf65ca537432bdc81f5b081d9"
  end

  depends_on "openjdk@8"

  def install
    rm Dir["*.bat"]
    mv "jvmtop.sh", "jvmtop"
    chmod 0755, "jvmtop"

    libexec.install Dir["*"]
    (bin/"jvmtop").write_env_script(libexec/"jvmtop", Language::Java.java_home_env("1.8"))
  end
end
