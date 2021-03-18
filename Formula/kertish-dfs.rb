class KertishDfs < Formula
  desc "Kertish FileSystem and Cluster Administration CLI"
  homepage "https://github.com/freakmaxi/kertish-dfs"
  url "https://github.com/freakmaxi/kertish-dfs/archive/v21.2.0066.tar.gz"
  sha256 "f76db2e933c1a3ad952f750d08712ca5ec664fc7e3e9acdf6fac98349e9b170d"
  license "GPL-3.0-only"
  head "https://github.com/freakmaxi/kertish-dfs.git"

  depends_on "go" => :build

  def install
    cd "fs-tool" do
      system "go", "build", *std_go_args, "-ldflags", "-X main.version=#{version}", "-o", "#{bin}/krtfs"
    end
    cd "admin-tool" do
      system "go", "build", *std_go_args, "-ldflags", "-X main.version=#{version}", "-o", "#{bin}/krtadm"
    end
  end

  test do
    port = free_port
    assert_match("failed.\nlocalhost:#{port}: head node is not reachable",
      shell_output("#{bin}/krtfs -t localhost:#{port} ls"))
    assert_match("localhost:#{port}: manager node is not reachable",
      shell_output("#{bin}/krtadm -t localhost:#{port} -get-clusters", 70))
  end
end
