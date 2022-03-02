class KertishDfs < Formula
  desc "Kertish FileSystem and Cluster Administration CLI"
  homepage "https://github.com/freakmaxi/kertish-dfs"
  url "https://github.com/freakmaxi/kertish-dfs/archive/v22.2.0147.tar.gz"
  version "22.2.0147-532592"
  sha256 "a13d55b3f48ed0e16b1add3a44587072b22d21a9f95c444893dbf92e19ee5cee"
  license "GPL-3.0-only"
  head "https://github.com/freakmaxi/kertish-dfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf7f947642a17c024dafd70f2f291adc818466e71d5596677ea19d87f0c41fa6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a9015a0c6be0e921eb0470d04812a17c894d294cffed43e78b4e7a2b7080271"
    sha256 cellar: :any_skip_relocation, monterey:       "b1dc66436cc1efb40b9aca2aaf0843a1bd07c019add74629b424a16b9e54020f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9bcc0055874504298902d5cb6b5e227c0b38ad7ae43ad7862e4bb44a2cfd9d7"
    sha256 cellar: :any_skip_relocation, catalina:       "00518fa80ad894cd6b0bc1b847a1b15fc25ba6cc98e8880c9d16a0d11a9f1a1e"
    sha256 cellar: :any_skip_relocation, mojave:         "1286f6d85148c7fc94ba9a1987fe202f5fe4b24295fb164884c950a2b46adeb4"
  end

  depends_on "go" => :build

  def install
    cd "fs-tool" do
      system "go", "build", *std_go_args(output: bin/"krtfs", ldflags: "-X main.version=#{version}")
    end
    cd "admin-tool" do
      system "go", "build", *std_go_args(output: bin/"krtadm", ldflags: "-X main.version=#{version}")
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
