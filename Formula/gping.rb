class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/gping-v1.7.0.tar.gz"
  sha256 "e40c8c89f8dd7b7f17f391a039817171c54128612c9b989b280f11bf07d1f511"
  license "MIT"
  head "https://github.com/orf/gping.git", branch: "master"

  # The GitHub repository has a "latest" release but it can sometimes point to
  # a release like `v1.2.3-post`, `v1.2.3-post2`, etc. We're checking the Git
  # tags because the author of `gping` requested that we omit `post` releases:
  # https://github.com/Homebrew/homebrew-core/pull/66366#discussion_r537339032
  livecheck do
    url :stable
    regex(/^gping[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "274888e9f1280f8f769a1cf97631c5daa97125fa4876046d4a9fba930290e555"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9916a629a28005ce21c107a838c35ec8da1d4663fbeebc23c9c68b01a0698c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28555a6f27330012d92a94e997e3c3df73f89b2a55eddd3bbd333ce0f134f37f"
    sha256 cellar: :any_skip_relocation, ventura:        "f5ca5493559293796fcaed2bf1e578fa2a91e23cf3914811d892427466b85500"
    sha256 cellar: :any_skip_relocation, monterey:       "0ab088d1be8f35647da3936663f5977f5c2fd1d489c170b072465a60d19c9ead"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9197b7cc5236ade7331c48a28f8e85ab4e2639264f0fb2bf96a99b57a41a4f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a804dc4aba65f0cc264444c88421c4a3325ab750c6d5541a9faae8bd88cf14a"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "iputils"
  end

  def install
    cd "gping" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    require "pty"
    require "io/console"

    r, w, pid = PTY.spawn("#{bin}/gping google.com")
    r.winsize = [80, 130]
    sleep 1
    w.write "q"

    begin
      screenlog = r.read
      # remove ANSI colors
      screenlog.encode!("UTF-8", "binary",
        invalid: :replace,
        undef:   :replace,
        replace: "")
      screenlog.gsub!(/\e\[([;\d]+)?m/, "")

      assert_match "google.com (", screenlog
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
