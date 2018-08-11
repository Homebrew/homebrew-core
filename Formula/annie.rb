class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.7.15.tar.gz"
  sha256 "73e26dd5ba0ed1d767d79d0d7f9f0182cf3443585ea6f858afb964df6d79a1b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e027cf3e9233aacd9e419f44b3b9b87d8ef5872c56d90c5154e7a9c33a0f4ed" => :high_sierra
    sha256 "fe2f250a68b80a86f679c44f1fa620968850ceb8d574e3224b9c317d9944266d" => :sierra
    sha256 "d8d702637b65cfe88aa25d9a79b682c3ff400b8ecae8706ce0f17d0bb5618da5" => :el_capitan
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
