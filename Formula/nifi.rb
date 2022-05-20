class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.16.1/nifi-1.16.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/1.16.1/nifi-1.16.1-bin.tar.gz"
  sha256 "c02fa82aaf101842ae0fa076d8dcbdd8d2b4cf74812a64684c48addef017250b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9c2a6d702f4e88694fe6c4f0ee20968b22e8c429a5e90a2f99fe5cb254668c26"
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
