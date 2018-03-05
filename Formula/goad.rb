class Goad < Formula
  desc "AWS Lambda powered, highly distributed, load testing tool built in Go"
  homepage "https://goad.io/"
  url "https://github.com/goadapp/goad.git",
      :tag => "2.0.4",
      :revision => "e015a55faa940cde2bc7b38af65709d52235eaca"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6992780a4e3c773e30ab9d57a8000618d6da51973224e8f325fe6f1c25cbceb" => :high_sierra
    sha256 "49f467700edf1b3bfc0564562bb55c2dd7ee758449bdd17903242cae6e11e6df" => :sierra
    sha256 "884d65d177cc21ff4ba6dc1e9bbd6f11c2ebaa6c77ffeb6a2bd148f3e3b8a926" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/goadapp/goad"
    dir.install buildpath.children

    cd dir do
      system "make", "build"
      bin.install "build/goad"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/goad", "--version"
  end
end
