class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.9.4.tar.gz"
  sha256 "0917116575104c104c9fd3950e73a24fd5f20e097d7eb1af4ee4e15df3016d63"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb9dfc945a8ddc1e4a643c89c7c71231350679f0d7f9e739afc9479fcb64c219" => :mojave
    sha256 "e104bf09692e7e10734a342794b7fed9e21a5a06e9cfa403240a8fa3575f66bf" => :high_sierra
    sha256 "814e6efc0efda8137454dc4ef38059e5ef54b68aec029c168966518c70d7f220" => :sierra
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
