class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/gping-v1.2.3.tar.gz"
  sha256 "d9b8ad4c9a978a3ca62d5af11274c8484bfa171e0b34faacd44cd7c54756a01d"
  license "MIT"
  head "https://github.com/orf/gping.git"

  # The GitHub repository has a "latest" release but it can sometimes point to
  # a release like `v1.2.3-post`, `v1.2.3-post2`, etc. We're checking the Git
  # tags because the author of `gping` requested that we omit `post` releases:
  # https://github.com/Homebrew/homebrew-core/pull/66366#discussion_r537339032
  livecheck do
    url :stable
    regex(/^gping[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fc164e14a50a5dc25400542b55cc403051f70bf87f11dc3ea0a4d19d48943b3a"
    sha256 cellar: :any_skip_relocation, big_sur:       "8574a0fd314ddfd911b85dc9a1cf4463e15cb470f867eab5eae9f9ccaa4af7a4"
    sha256 cellar: :any_skip_relocation, catalina:      "3346653e1695fd5eaa23d8b62ab16292e25b143679ef8f8effb61b3b82cfc8ae"
    sha256 cellar: :any_skip_relocation, mojave:        "1511dcaf2f0eaad03a622d04ec8c6dbfc1fcff831aa10e8faea836b19995cc3a"
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
