class BoreCli < Formula
  desc "Modern, simple TCP tunnel in Rust that exposes local ports to a remote server"
  homepage "https://github.com/ekzhang/bore"
  url "https://github.com/ekzhang/bore/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "cf821106ed428314d825ebe2d09f1842f979eac7acbf0976ac9cd01853d65163"
  license "MIT"
  head "https://github.com/ekzhang/bore.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d465f61200bf68616f4af90759353837da2b25ea2ddfad5515ff0720b96eb45d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c619d3462869a1fc46282a7d529dc68aa304a6e53e88a52135c682bc86ef4b14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d13631a08f76043f5f6bdca2fed25dbefabcb39dcb157b2c5d72200e5761dcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ffe3208657a91339bf71743df476ab60188336afe6cab80f18c296c5c0a985a"
    sha256 cellar: :any_skip_relocation, ventura:       "6e29b8b5a51458d8c9559bc7ffd8f6cd5433b222ec06d374a9584af7a81f9d38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0344bdd72eb8d0b6d36d734feedacddc5c3c1af9f30e7fd1389d8f5bc7732bcc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    _, stdout, wait_thr = Open3.popen2("#{bin}/bore server")
    assert_match "server listening", stdout.gets("\n")

    assert_match version.to_s, shell_output("#{bin}/bore --version")
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
