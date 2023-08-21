class Dex2jar < Formula
  desc "Tools to work with Android .dex and Java .class files"
  homepage "https://github.com/pxb1988/dex2jar"
  url "https://github.com/pxb1988/dex2jar/releases/download/v2.1/dex2jar-2.1.zip"
  sha256 "7a9bdf843d43de4d1e94ec2e7b6f55825017b0c4a7ee39ff82660e2493a46f08"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "19befbca4d509e7895c346200eb08faf8fba035a297760bc6e3f60785901add1"
  end

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm_rf Dir["*.bat"]

    # Install files
    prefix.install_metafiles
    chmod 0755, Dir["*"]
    libexec.install Dir["*"]

    Dir.glob("#{libexec}/*.sh") do |script|
      (bin/File.basename(script, ".sh")).write_env_script script, Language::Java.overridable_java_home_env
    end
  end

  test do
    system bin/"d2j-dex2jar", "--help"
  end
end
