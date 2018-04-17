class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.6.6.tar.gz"
  sha256 "e9b25727ad651951d04e5649271cf639c9745d0577143ba0ce15d205c4dced87"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a8ca1fef24f62d6a096ae54327e9bf00f4d5c20aafacbcaea4c1a356279a158" => :high_sierra
    sha256 "93f431af54ea423e9ba851e889d3158651252010b79b61fc8b8ee85dfa63484f" => :sierra
    sha256 "bb11e1775f2627c8f06cf843775eca821881301961a841cfe9029a76a15ba07a" => :el_capitan
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
