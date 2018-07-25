class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.7.11.tar.gz"
  sha256 "753a121f19f918cd86b17b8473251e1cebeb55801030f00e8c3ca952be956fe8"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8bc55ab6777abebab16b778d4834ea91614d37608cdc8f1e1d9ac45e07470c7" => :high_sierra
    sha256 "a9a6f9740c6f4ee69d68d916d32ddeff3b35a8b78f4f3af61d7a31440e9d0ae4" => :sierra
    sha256 "9e64ca33b780d8644a5c453d53fc8acdea49a890662eafe5792d369ec111458f" => :el_capitan
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
