class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.2.0/nifi-2.2.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.2.0/nifi-2.2.0-bin.zip"
  sha256 "e23e86440ee26abf90345f85b0152900b02d2dab7353cb5812c937dbce3dfa08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d60de663051ad4827d0b5d5e8be4df3c9b5483ef9c1b82c1327c6ff8c1fd804c"
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
