require "formula"

class Massren < Formula
  homepage "https://github.com/laurent22/massren"
  url "https://github.com/laurent22/massren/archive/v1.5.1.tar.gz"
  sha256 "21a602a29410e30b1b518356d5707b25b22b9d2578aaf0d0d5ab3de9e0ad225d"
  version "1.5.1"
  
  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    system 'go', 'get', '-u', 'github.com/jessevdk/go-flags'
    system 'go', 'get', '-u', 'github.com/kr/text'
    system 'go', 'get', '-u', 'github.com/laurent22/go-sqlkv'
    system 'go', 'get', '-u', 'github.com/laurent22/go-trash'
    system 'go', 'get', '-u', 'github.com/mattn/go-sqlite3'
    system 'go', 'get', '-u', 'github.com/nu7hatch/gouuid'
    system 'go', 'build', '-o', 'massren'
    bin.install 'massren'
  end
end
