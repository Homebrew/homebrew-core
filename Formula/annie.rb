class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.8.0.tar.gz"
  sha256 "ba3f328328ed6b80ef1d079944f3b6817619fef5289f70398d0da3b7d6e7c8bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "490652a35cb459163d9468f2cd6d6adde53ce31d655f10ef0b5796ab6fb0c443" => :mojave
    sha256 "dd5bdf85148fe47ab6b72f1e25ec492ac494ca41e5ab1413b8658da629a37dc0" => :high_sierra
    sha256 "d54d9db9fedb5520722335b88b6e90f4bab84b82bdd9f68045fe8f4c92f73877" => :sierra
    sha256 "f3f0fca323d2170ee9a784062fc1b53445581584dbd921080e80a3ad1323236f" => :el_capitan
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
