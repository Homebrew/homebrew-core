class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https://github.com/curlpipe/ox"
  url "https://github.com/curlpipe/ox/archive/0.2.7.tar.gz"
  sha256 "ae08c18243b66d8c24f9e0844e499890be2864584a8d3e38f186fdf3aa5c09fc"
  license "GPL-2.0-only"
  head "https://github.com/curlpipe/ox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db8e62ab63880a852649df5abf70a6c327938d3976f037e4b9669ffd960e7ebf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8db3c16dd26d2465bb502ba4a8a9a395b5f994a8ad1918ae6ca807578bebf331"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbed75de05d6ff3bfd805c6534f41a6a0c7c2b7969c76028ad8075733569784a"
    sha256 cellar: :any_skip_relocation, ventura:        "2038f6d47418ec55d1791984a8e75f8e0fc7ed52d540cdd292c64ac148cb0be5"
    sha256 cellar: :any_skip_relocation, monterey:       "c206120daa4a96c5982eac790002bce0d07c3f7d4f784ca338938a742a8c0bec"
    sha256 cellar: :any_skip_relocation, big_sur:        "8581f482c082a10780837652b351723c0b8ccb0a6093180a7830e1d789a4d76c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7558585f65e9b5753616dabc187da65bac2a047c2cd443f839da029632ad221d"
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
