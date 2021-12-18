class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.15.1/nifi-1.15.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist//nifi/1.15.1/nifi-1.15.1-bin.tar.gz"
  sha256 "dd2d99dee4bba61aa4e2c977297937301a23dd296ecfa8f13d5863054ccde512"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7d1b3311d1d34c1adbd6228c773725c8e9dfe166779b0984f0549c84e759de40"
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
