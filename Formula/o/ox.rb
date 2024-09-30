class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https://github.com/curlpipe/ox"
  url "https://github.com/curlpipe/ox/archive/refs/tags/0.6.3.tar.gz"
  sha256 "0e5dc566589dab9e24196b13ecf1522525fe71fbced7f3d964aacbe10fda0f4d"
  license "GPL-2.0-only"
  head "https://github.com/curlpipe/ox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b50ee2f20d355a2469cedb31e879ce9c117fb75829a0ecfca3b15da0235c02d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "276cdc577c3c4940a450547bf5fb1fc266abe4c285f6eb27146434ad0fe482ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e34fe3804a1ad73160e5b30b3d78fb6a10bc76577cc9dd5cd3f7f783a90ced5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f51c5cda3e54d3a059b7c1a7d1e72c7a89e470bea56c562e6be9e740a71296a5"
    sha256 cellar: :any_skip_relocation, ventura:       "4def6094a9a001f7a4451ae756a2d1b99c1bd3445b4964d93b4706b6da2a2cca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e822a4e038b89cdc396f7154e4d82fc96ebb4da435cfdc1a29ba17f981bb04ed"
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
