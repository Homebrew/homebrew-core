class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https://github.com/curlpipe/ox"
  url "https://github.com/curlpipe/ox/archive/refs/tags/0.6.7.tar.gz"
  sha256 "cfed456ebe31dbe5fd13fc87ec4cb7e24d8b989f5878e14963c0a534ca5259e7"
  license "GPL-2.0-only"
  head "https://github.com/curlpipe/ox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c407d267f9448c5ad7bb4b7f1d067358d5df8f4faa1acb9ed6268d23483a121"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e796365299ca67bd1113ebad3bd484f3e37034038824b20106fce6fe44ab9e1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56a7ce8d3363a69fa68f4a93c68efe6cd5f1ac096647360a97a80a457e604a7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "43088160e3d767fcce27bff75412f696e9095ba2bc034e2ab5fd9210abd20c42"
    sha256 cellar: :any_skip_relocation, ventura:       "fc36c63c2cbd10a21c8bd1e3a88c5bb70e32fbeb44f7a74c55f35e6840a1f7b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff772ea71cb617978958e752e399bb05427b7a17d900ab10e2e06bf5b0d7d260"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Errno::EIO: Input/output error @ io_fread - /dev/pts/0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    require "pty"
    ENV["TERM"] = "xterm"

    PTY.spawn(bin/"ox", "test.txt") do |r, w, pid|
      sleep 1
      w.write "Hello Homebrew!\n"
      w.write "\cS"
      sleep 1
      w.write "\cQ"
      r.read

      assert_match "Hello Homebrew!\n", (testpath/"test.txt").read
    ensure
      Process.kill("TERM", pid)
    end
  end
end
