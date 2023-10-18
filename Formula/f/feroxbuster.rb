class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "687f4b9a09ab146355fcaef132307b0cd802923728ba1fe14029a115f841be57"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a0fdbc7203fec6f36f159ec7eed93fb383bef4ffa78d9b9f4d5c86273b6fd5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a7c91adcf90e281694f90a5ea33ec92068f0b6a0b426d478be48335105ed975"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "010d675e1629077aa018763a45e6125ac7edede22a464566fbef7e44c41416b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9185a16b5d3b998c1921e02c3ccae5e2a88ebddc0ba9dc626b39e924dc493fda"
    sha256 cellar: :any_skip_relocation, sonoma:         "8eda22acc1b3846f7687ad2d44eba828b2a6109be634e71bad80e41f23ce7ebf"
    sha256 cellar: :any_skip_relocation, ventura:        "429d9d168d9dea419aa46ccb34685e2f78b29d7fe59289831d42313c7b91eedb"
    sha256 cellar: :any_skip_relocation, monterey:       "835ec2a320d469fe834e1a8732323055e9949d18e3ad45d590fccba12106a5d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "826829187418f0376b5aa84e669a0713cfd26a4dee8a31ea005f13ec311bae19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e778a0c7984dbc9077871f5446e21ef7f565ff95f8a03027df0b72db4808a47"
  end

  depends_on "rust" => :build
  depends_on "miniserve" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"wordlist").write <<~EOS
      a.txt
      b.txt
    EOS

    (testpath/"web").mkpath
    (testpath/"web/a.txt").write "a"
    (testpath/"web/b.txt").write "b"

    port = free_port
    pid = fork do
      exec "miniserve", testpath/"web", "-i", "127.0.0.1", "--port", port.to_s
    end

    sleep 1

    begin
      exec bin/"feroxbuster", "-q", "-w", testpath/"wordlist", "-u", "http://127.0.0.1:#{port}"
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
