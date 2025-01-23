class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.1.0/nifi-2.1.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.1.0/nifi-2.1.0-bin.zip"
  sha256 "5105062aa684ceb11d05e6536f3c8ca6fde957b785f1f341021ea29911cf7948"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eba45458e2a9ccc9a2b59619e69439fd0e4c1c4eff4e97a638cccd2da2f1629e"
  end

  depends_on "openjdk@21"

  def install
    libexec.install Dir["*"]

    (bin/"nifi").write_env_script libexec/"bin/nifi.sh",
                                  Language::Java.overridable_java_home_env("21").merge(NIFI_HOME: libexec)

    # ensure uniform bottles
    inreplace libexec/"python/framework/py4j/java_gateway.py", "/usr/local", HOMEBREW_PREFIX
  end

  test do
    system bin/"nifi", "status"
  end
end
