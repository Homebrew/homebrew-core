class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.8.4.tar.gz"
  sha256 "b12794ebe0ab50bc4992bd72c41318519cdc602c9cb96a01568433df58601b42"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a8486e8d6681711843968a1255b6e168a13317ec7e0f6363f1b08fef05cd31f" => :mojave
    sha256 "684660188c71929cc3ca0293b8928db165d33e8396b9f58d128d9f0b8de8f06d" => :high_sierra
    sha256 "c15588bb81f42b1fc5147a2a108a8e2ea86b69e87214ad9a50087eed6b830fe6" => :sierra
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
