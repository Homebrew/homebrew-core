class Dex2jar < Formula
  desc "Tools to work with Android .dex and Java .class files"
  homepage "https://github.com/pxb1988/dex2jar"
  url "https://downloads.sourceforge.net/project/dex2jar/dex2jar-2.0.zip"
  mirror "https://bitbucket.org/pxb1988/dex2jar/downloads/dex2jar-2.0.zip"
  sha256 "7907eb4d6e9280b6e17ddce7ee0507eae2ef161ee29f70a10dbc6944fdca75bc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/dex2jar[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d46040686d7dee6a12faa0877a80d4d8cfb285c98681d081eb5a05e31098586c"
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
