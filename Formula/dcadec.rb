class Dcadec < Formula
  desc "DTS Coherent Acoustics decoder with support for HD extensions"
  homepage "https://github.com/foo86/dcadec"
  url "https://github.com/foo86/dcadec.git",
      :tag => "v0.2.0",
      :revision => "0e074384c9569e921f8facfe3863912cdb400596"
  head "https://github.com/foo86/dcadec.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "68b350a3ec6a1ab7384eac3341a03762e8233dec742c35f8dc2afc213b3db567" => :mojave
    sha256 "7f938bcd68b9078df3dc6e67d82e08beb55b10228a808d91543a6ed2d15a2002" => :high_sierra
    sha256 "7a51fb1bfa07f08c45176df419087429e9ffce945cbcd28d71e403c456762c74" => :sierra
    sha256 "89ddc5e9a5cfd72e604bdff54ee1f09f9ad4ec281fc79c93201971bbd380ccdd" => :el_capitan
    sha256 "640914a5ce466bbb91b551bdb35a385e4a8b08c25f78509a16c016c654963805" => :yosemite
    sha256 "6d373b4fe5dbb76648183d83cd3161970e8f3674ea29a3133fa4d3c0a9f82ca1" => :mavericks
  end

  resource "sample" do
    url "https://github.com/foo86/dcadec-samples/raw/fa7dcf8c98c6d/xll_71_24_96_768.dtshd"
    sha256 "d2911b34183f7379359cf914ee93228796894e0b0f0055e6ee5baefa4fd6a923"
  end

  def install
    system "make", "all"
    system "make", "check"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    resource("sample").stage do
      system "#{bin}/dcadec", resource("sample").cached_download
    end
  end
end
