class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.8.2.tar.gz"
  sha256 "9fdaedb1ee6ec0b677471c05013c3516628278f6a5a27156c08ce6e56fc60806"

  bottle do
    cellar :any_skip_relocation
    sha256 "323367789e64db6b6cb6352863641311e34c0ab20329cc0ccc17110c9a962869" => :mojave
    sha256 "a53b533ded4bd30d4fd440927bcae74d403c735c4acfd94f31f7ebd0a4e40e86" => :high_sierra
    sha256 "52b545fe25244024a3a9e487778a69e04efac9faf5c89836aabac04f55f8b6d6" => :sierra
    sha256 "ba33accd8792a3a4135b4a2e391517f2a6466dd2208ba38ee5ecc0e6336396b3" => :el_capitan
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
