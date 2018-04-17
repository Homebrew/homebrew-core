class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.6.6.tar.gz"
  sha256 "e9b25727ad651951d04e5649271cf639c9745d0577143ba0ce15d205c4dced87"

  bottle do
    cellar :any_skip_relocation
    sha256 "20d4b4e69e29ee24e206e1f401e4acb087878b41c3e041fcdd19e5c570cdec62" => :high_sierra
    sha256 "724a233949e5376acaf209f6e2c65425e2868505e82c2410f825d83c4287b67a" => :sierra
    sha256 "a97aa4fac379515b90c30e1cd2f5bdd2c25ef64ec3f81f3956856ae4ac8eb739" => :el_capitan
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
