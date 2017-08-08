class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro/releases/download/v1.3.1/micro-1.3.1-src.tar.gz"
  sha256 "fdede583ea2f67588c42be30a820699acc376d59f0652ca0b50c9120511f2caf"
  head "https://github.com/zyedidia/micro.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "3d6b9d548f9e7ad12eb2648a9276c28b910bc95da557dbd5322a138a1bf9750e" => :sierra
    sha256 "9616b3ca262556b887d9a4f8dc2bb2ed1487606b08ad930408afa5e540cc2dd5" => :el_capitan
    sha256 "8cbbf1cec882bf73ec86e95ca77d0046cba8d3885e2721c3ba435b9bce5de0f2" => :yosemite
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
