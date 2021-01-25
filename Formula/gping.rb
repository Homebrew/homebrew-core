class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/v1.2.0.tar.gz"
  sha256 "2379d2d5c3e301140d9c65c4dcc2b99602acf511b2798f45009af4c1101a0716"
  license "MIT"
  head "https://github.com/orf/gping.git"

  # The GitHub repository has a "latest" release but it can sometimes point to
  # a release like `v1.2.3-post`, `v1.2.3-post2`, etc. We're checking the Git
  # tags because the author of `gping` requested that we omit `post` releases:
  # https://github.com/Homebrew/homebrew-core/pull/66366#discussion_r537339032
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ad76726fb0897f1960e045b31d6a080a1c699a5ebe187f1b5f3fabb1575afe90" => :big_sur
    sha256 "4deb2a242ab4de0d179b8328c74fb585cdbc0078e6074bea366415606e0b1f86" => :arm64_big_sur
    sha256 "c8162661b26ec98036c7abd06916867fb715f1c6b0881fe41ce7bbd292773f07" => :catalina
    sha256 "9c0a56c20f3c378227ae9288ff6b88d0eb2f3f1cbd33dcb493226dab1b894ad8" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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
    screenlog.gsub! /\e\[([;\d]+)?m/, ""

    assert_match "google.com (", screenlog
  ensure
    Process.kill("TERM", pid)
  end
end
