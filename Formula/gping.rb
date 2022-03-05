class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/gping-v1.3.0.tar.gz"
  sha256 "6624ccfcd0abec42e356e8b09e4a33fe04c66c4d32a805235f984d3a7624ed8f"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "852c475739cf0cfea34be4278aa155cfd058827cbb4f0734d6807e12d159e583"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4bc95277caa9a0270008e1a47639c048b1629e170cb5c823c74d0b05df4fcb8"
    sha256 cellar: :any_skip_relocation, monterey:       "de245cccf18d4d9d67c438d26f3afebf86ef3d602a0868c6f9ea8ae6dd59fc4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f390cbd28ff85efb7b9fb83b40d08b2246a70dd518598bc41d4a5d54024475c"
    sha256 cellar: :any_skip_relocation, catalina:       "bb87a7bd3c4cb82ba34e2047b8a76d07956b0b9b3188187633504b60a6f31011"
  end

  depends_on "rust" => :build

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

    screenlog = r.read
    # remove ANSI colors
    screenlog.encode!("UTF-8", "binary",
      invalid: :replace,
      undef:   :replace,
      replace: "")
    screenlog.gsub!(/\e\[([;\d]+)?m/, "")

    assert_match "google.com (", screenlog
  ensure
    Process.kill("TERM", pid)
  end
end
