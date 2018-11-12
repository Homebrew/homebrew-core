class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.8.3.tar.gz"
  sha256 "f976c44490431b2ff118da7d007c1145d7f03fd0b27d24dcff8a39ae0e8a6fe0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c7d641fa6b7c7b797de408dd1388cddfe4c1e8e46f038996b9944e2e77f825fe" => :mojave
    sha256 "4cd746f3a63f66d21a35ac346e02d827661f60956a670500c8394a669f4f9e2f" => :high_sierra
    sha256 "b45cd6225607a57d57b3c4aaf287da6517831d246967dfae4bb639234f2943a8" => :sierra
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
