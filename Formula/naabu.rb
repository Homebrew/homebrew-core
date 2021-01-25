class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/v2.0.3.tar.gz"
  sha256 "ec967a094f4de76880072f83db830745d4b34ce8f41b14047d8158187ec14212"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "76af89c3ff6b834a4ab16b86e981b761ed2811630bc99675f5516ab7fd6c96c0" => :big_sur
    sha256 "ae9dbd299ba99a226616d232b3b75882428bce0828a1dc32abe56c5de58fd0d9" => :arm64_big_sur
    sha256 "ca6a24af7e25bc3ded93af7982de6e5568a12cbc13d291a484e41d55f652f77b" => :catalina
    sha256 "74c393d06df9c4dfb29165803b573378f4beacb4b979e07c3d68b4972ba45eec" => :mojave
  end

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args, "./cmd/naabu"
    end
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")
  end
end
