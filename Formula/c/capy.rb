# instruction followed here: https://docs.brew.sh/Formula-Cookbook#an-introduction

class Capy < Formula
  desc "Copilot for Antifragile System AI"                              # A description of the software
  homepage "https://github.com/AntiFragile-AI/copilot/"                          # url to homepage
  url "https://github.com/AntiFragile-AI/copilot/releases/download/v1.0.0/capy-1.0.0.tar.gz"   # url for the archive
  sha256 "2c509b20ef2014b5942a43f47731fa008cb8fc21a0e65f70f485cf934e728354"         

  # Additional options, dependencies, and installation steps go here
  depends_on "python"


  def install
    print "install capy!"
    bin.install "capy_script.sh" => "capy"
  end
  
  test do
    system "#{bin}/capy", "--version"
  
  end
end