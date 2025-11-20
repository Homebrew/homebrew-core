class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.6.0/nifi-2.6.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.6.0/nifi-2.6.0-bin.zip"
  sha256 "dd6c32d92c82d47770954c46de8a834236b80f624ad8a0429c943a961f75951a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ac825f02b66cae8742b1d350a98d2e85acbf13fb4978e682c921504605f3143d"
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
