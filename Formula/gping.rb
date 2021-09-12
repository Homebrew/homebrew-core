class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/gping-v1.2.5.tar.gz"
  sha256 "de1c6bd2b51d71194eccaeb1ba6559e92a0f9ef272d0cfdf2613fe35d42b042a"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7b4302de0e2b8c34e2998caa9c3f025a69c841366782bac1f8bec2101c30d169"
    sha256 cellar: :any_skip_relocation, big_sur:       "6a9292d8507ad6a54a9a8f75b2cdf87aada11d03e22ef3e6ce55fd460877542b"
    sha256 cellar: :any_skip_relocation, catalina:      "33f2fd8410335acc5ab02bab938074834d7b610abef711c8b1b3ad842ed64443"
    sha256 cellar: :any_skip_relocation, mojave:        "5ee916f0fa2d952b9ba1b79d87d635c8c3b1cbcddae80b0998c6c076197b6bd4"
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
