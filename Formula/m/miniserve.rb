class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "c4c5e12796bdae2892eff3832b66c4c04364738b62cf1429259428b03363d1f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c5a16ad48eadc894131a875091d1b19107721c2bb36464765e42012020d9a48a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6cc10cf16ca85666a77e70f4bd57bfb157c32f0b4d5a605847bd6c687868a66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e994ff3f1800725951a60884f93fccd05badb165f1245c8419c270392d671b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cb916ec796c97f84352cc13f63128780b62481bc8ec66a2f0c31037e69e5a94"
    sha256 cellar: :any_skip_relocation, sonoma:         "ccf0b0cfa48e87739289f56839e79e009ea127074c392efd6ee502c2564c1ade"
    sha256 cellar: :any_skip_relocation, ventura:        "c5163f3e1e1ff80ada46fc814f2da5698613cdb92e5cc5cfd726ae7cf7dc8506"
    sha256 cellar: :any_skip_relocation, monterey:       "78cceaca14f67f7e211a310f86bf8c85c6fca302a190a90bb89cbb2ff6dd79a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78e575b93ef33f7fab95beb3203edd3648de63abdcabdca011ea001c41dc2f6d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"miniserve", "--print-completions")
    (man1/"miniserve.1").write Utils.safe_popen_read(bin/"miniserve", "--print-manpage")
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"miniserve", bin/"miniserve", "-i", "127.0.0.1", "--port", port.to_s
    end

    sleep 2

    begin
      read = (bin/"miniserve").read
      assert_equal read, shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
