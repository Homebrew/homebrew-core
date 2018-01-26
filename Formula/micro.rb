class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro/releases/download/v1.4.0/micro-1.4.0-src.tar.gz"
  sha256 "2b36a4e7f69e6bb48591527454a93ff781db8e8a94dc646e934f6a3de862d40b"
  head "https://github.com/zyedidia/micro.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "d661fa8c03d2f80da25d4f2ac27e2a3aade2a291e5c458aded3935d0040e2769" => :high_sierra
    sha256 "3997514193806b65975f1e8fe1e613cca6cfb389f3b160deb93db3ed1e2589ab" => :sierra
    sha256 "5ed6f6fa32e3604d4a3fd186de8d63a6ecb89df7f2399bca680c08be466a11d3" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/zyedidia/micro").install buildpath.children

    cd "src/github.com/zyedidia/micro" do
      system "make", "build-quick"
      bin.install "micro"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end
