class KertishDfs < Formula
  desc "Kertish FileSystem and Cluster Administration CLI"
  homepage "https://github.com/freakmaxi/kertish-dfs"
  url "https://github.com/freakmaxi/kertish-dfs/archive/v21.2.0066.tar.gz"
  sha256 "1ff300a803a0d3bd068e1492319a771912cccd4ba3a72098b6d05678813af966"
  license "GPL-3.0-only"
  head "https://github.com/freakmaxi/kertish-dfs.git"

  depends_on "go" => :build

  def install
    system "go", "mod", "download"
    cd "fs-tool" do
      system "go", "build", "-trimpath", "-ldflags", "-X main.version=#{version}", "-o", "#{bin}/krtfs"
    end
    cd "admin-tool" do
      system "go", "build", "-trimpath", "-ldflags", "-X main.version=#{version}", "-o", "#{bin}/krtadm"
    end
  end

  test do
    assert_match(/failed.\nlocalhost:39400: head node is not reachable\n$/,
      `#{bin}/krtfs -t localhost:39400 ls`)
    assert_match(/localhost:39400: manager node is not reachable\n$/,
      `#{bin}/krtadm -t localhost:39400 -get-clusters`)
  end
end
