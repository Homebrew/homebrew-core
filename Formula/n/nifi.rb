class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.13.0/nifi-2.13.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.13.0/nifi-2.13.0-bin.zip"
  sha256 "9e08620e8a329148448da1f3ab5020b4684478797cac059cb44f42bc5c2e700d"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "ebd3d85824bb99e6c8d110d3e333f31bd1f26ca85ef8b12379fb581514dd6031"
    sha256 cellar: :any_skip_relocation, all: "efe0c047f4f66390ca8dcb65bb75ac5c3addceb6b1a78ab8c868a623e0f2bc00"
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
