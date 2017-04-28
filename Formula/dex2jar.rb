class Dex2jar < Formula
  desc "Tools to work with Android .dex and Java .class files"
  homepage "https://github.com/pxb1988/dex2jar"
  url "https://github.com/pxb1988/dex2jar/releases/download/2.1-nightly-26/dex-tools-2.1-20150601.060031-26.zip"
  mirror "http://repository-dex2jar.forge.cloudbees.com/snapshot/com/googlecode/d2j/dex-tools/2.1-SNAPSHOT/dex-tools-2.1-20150915.140224-29.zip"
  sha256 "059d4817c4279b295a778446060b6bbc98dda01fad95fec8d331736f0852d5db"

  bottle :unneeded

  def install
    # Remove Windows scripts
    rm_rf Dir["*.bat"]

    # Install files
    prefix.install_metafiles
    chmod 0755, Dir["*"]
    libexec.install Dir["*"]

    Dir.glob("#{libexec}/*.sh") do |script|
      bin.install_symlink script => File.basename(script, ".sh")
    end
  end

  test do
    system bin/"d2j-dex2jar", "--help"
  end
end
