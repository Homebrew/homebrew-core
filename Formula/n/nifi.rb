class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.23.2/nifi-1.23.2-bin.zip"
  mirror " https://archive.apache.org/dist/nifi/1.23.2/nifi-1.23.2-bin.zip"
  sha256 "477c08c496877122705d82fbe990c3ffd3c86baf7cbcac7f4e31e01e976d1179"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b59ec0f3816ad3a69190713e7f150c4971aa15ad4765a2a900c7279324a05dbe"
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
