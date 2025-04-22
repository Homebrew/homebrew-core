class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.3.0/nifi-2.3.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.3.0/nifi-2.3.0-bin.zip"
  sha256 "022806e16b7f43db06b148f329499ec5130226c33975119824370717d61474d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c8b8f5ca37382ed05872957a5b1d282558b374473b853fe925b0e746c3776682"
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
