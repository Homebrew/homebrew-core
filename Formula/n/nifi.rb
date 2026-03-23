class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.8.0/nifi-2.8.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.8.0/nifi-2.8.0-bin.zip"
  sha256 "ffbca25d383454eb67af04330f1dce464af244addf0c604b91556f54f9ddadd7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7f378f643fdce80e5748668aea070f67e1b813282727b24f598a37969947b046"
  end

  depends_on "openjdk@21"

  def install
    libexec.install Dir["*"]

    (bin/"nifi").write_env_script libexec/"bin/nifi.sh",
                                  Language::Java.overridable_java_home_env("21").merge(NIFI_HOME: libexec)
  end

  test do
    system bin/"nifi", "status"
  end
end
