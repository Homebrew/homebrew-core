class KertishDfs < Formula
  desc "Kertish FileSystem and Cluster Administration CLI"
  homepage "https://github.com/freakmaxi/kertish-dfs"
  url "https://github.com/freakmaxi/kertish-dfs/archive/v21.2.0066.tar.gz"
  sha256 "1ff300a803a0d3bd068e1492319a771912cccd4ba3a72098b6d05678813af966"
  license "GPL-3.0"
  head "https://github.com/freakmaxi/kertish-dfs.git"
  version "21.2.0066"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "go" => :build

  def install
    system "go", "mod", "download"
    
    Dir.chdir('fs-tool') {
      system "go", "build", "-trimpath", "-ldflags", "-X main.version=#{version}", "-o", "#{bin}/krtfs"
    }

    Dir.chdir('admin-tool') {
      system "go", "build", "-trimpath", "-ldflags", "-X main.version=#{version}", "-o", "#{bin}/krtadm"
    }
  end

  def post_install
    puts "", "", "If you need Kertish Node Executables for v#{version}, please visit https://github.com/freakmaxi/kertish-dfs/releases/tag/v21.2.0066", "", ""
  end

  test do
    system "#{bin}/krtfs", "-v"
    system "#{bin}/krtadm", "-v"
  end
end
