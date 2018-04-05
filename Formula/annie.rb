class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.6.4.tar.gz"
  sha256 "e7f9caf29bf4b48e9329f0c7efba7988bcd2f8d0361b710022a40cd033164d4f"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c6f9a2806fda9385ea83f94a0f6923b6a6e8fd87d1857db49d8e6af0ce40b5d" => :high_sierra
    sha256 "c5edf4ebb40b059ab45269394cbea65ea35d820cd20516b3dc728fadee2b60d7" => :sierra
    sha256 "bcee207730d4e8f5b9810dcb316991bb30ffc27447bd53b088f2440ab2be0927" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/iawia002/annie").install buildpath.children
    cd "src/github.com/iawia002/annie" do
      system "go", "build", "-o", bin/"annie"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"annie", "-i", "https://www.bilibili.com/video/av20203945"
  end
end
