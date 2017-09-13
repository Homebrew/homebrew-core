class Certstrap < Formula
  desc "Tools to bootstrap CAs, certificate requests, and signed certificates"
  homepage "https://github.com/square/certstrap"
  url "https://github.com/square/certstrap.git",
      :tag => "v1.1.0",
      :revision => "25e0caa16bbb614597a4de836537084a16b28ca0"

  bottle do
    cellar :any_skip_relocation
    sha256 "99040a5b6c97739b0bc00ea3fb226bcc00a8e3e332cdb00c4885e4134e8f00de" => :sierra
    sha256 "f05948c7a18ed76b5cb1151cf3a1e3d3e4df10476116b3c478a279ce2fba4798" => :el_capitan
    sha256 "1d6ef4097beec1509a779140f2e5d60d772dfbaef52ce066f1967ebbe097eba0" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    system "./build"
    bin.install "bin/certstrap"
  end

  test do
    system "#{bin}/certstrap", "init", "--common-name", "Homebrew Test CA", "--passphrase", "beerformyhorses"
  end
end
