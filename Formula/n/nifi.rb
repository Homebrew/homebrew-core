class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.23.1/nifi-1.23.1-bin.zip"
  mirror " https://archive.apache.org/dist/nifi/1.23.1/nifi-1.23.1-bin.zip"
  sha256 "0baefb3aa8e555fe076d6cfbb95c95bbe66ab7a415064d353ef855237e222699"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "46c739145e6b886973a4718c59ec013e0f38ace36d15a618651a75ab9451f4b6"
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
