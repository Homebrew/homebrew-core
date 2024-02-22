class Gno < Formula
    desc "GNo is go - tools to generate node project"
    homepage "https://github.com/faanrm/go-node"
    url "https://github.com/faanrm/go-node/releases/download/v0.1.2/gno_v0.1.2_linux_386.zip"
    sha256 "2574e3ba467eea1238f8e7a3a4622dcd79d031cb972c9129963662afcfe9df50"
  
    def install
      bin.install "gno" 
    end
  
    test do
      system "#{bin}/gno", "--version"
    end
  end
  