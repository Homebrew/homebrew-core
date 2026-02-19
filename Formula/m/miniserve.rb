class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "eacef6128688c02409b0aba34c550a80fa5a714979c6c8e21e20c6a0aa2bc33a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51a652974e5b6cbc0c900aa59db2d90ee9b09bdc4eee6d4ac53439508aac1778"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "489497e4fd12e21775e64294921ae04dd4c584e227ffdd2128993dec836d28a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eae7278059d876c2e570d00c79d9d0ffcd33beb6a76177f3a914bc8d5ad269cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c234fcbed960c1ce0590db9111b6ced642f9b52ceb70ac09956f07775406da31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4054184cc0c0ae822c6e09b27b0b7134d96b0981b31631a328008a8689507c90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24966360e41ff69713840bfbac5c95c02bc9b55856123230745108787a1536f2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"miniserve", "--print-completions")
    (man1/"miniserve.1").write Utils.safe_popen_read(bin/"miniserve", "--print-manpage")
  end

  test do
    port = free_port
    pid = spawn bin/"miniserve", bin/"miniserve", "-i", "127.0.0.1", "--port", port.to_s

    begin
      sleep 2
      read = (bin/"miniserve").read
      assert_equal read, shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
