class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.16.2/nifi-1.16.2-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/1.16.2/nifi-1.16.2-bin.tar.gz"
  sha256 "27932e264c80985a12fa90439447c7db050f879b46398b74a09d9a734d74e147"
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
