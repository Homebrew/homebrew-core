class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.25.0/nifi-1.25.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/1.25.0/nifi-1.25.0-bin.zip"
  sha256 "ce314ddbc1471fc8c2b670abe4091d853a2f12ba2cc13354c166b15f9d965684"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "93862881ba6951b60f93a57a1872644bfd71dde1155dea55d6de838fd680eadf"
  end

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]

    (bin/"nifi").write_env_script libexec/"bin/nifi.sh",
                                  Language::Java.overridable_java_home_env("11").merge(NIFI_HOME: libexec)
  end

  test do
    system bin/"nifi", "status"
  end
end
