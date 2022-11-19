class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/gping-v1.4.0.tar.gz"
  sha256 "f68735ee9f6f3fde6881b727c518550d9c486a4259c0a2a2d261971715b77970"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ce394999f2228279a5bde05bb7d0244732d78343637c731ae0e8d5f2fdc04a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba98e3ea3e08849ca8a3ac4b622f5e3aa5e357de74b7b65e76630dc6aefa4371"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e8ac27706f3b4bf8a64692afac834faa5f290b5caa9e8a9f26f5f6791bf22be"
    sha256 cellar: :any_skip_relocation, ventura:        "ab5e6d447f11bc865ab8224435aae43970687bb8831c0585ee38063f81338856"
    sha256 cellar: :any_skip_relocation, monterey:       "3b4a86f1d7caab1de05751a7a9c53dc0ee17aca46201c55a109a3ccbb443f0ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fe8da43c36842820da42cf8aae7795c317ecf1685d023550becea6468ee191b"
    sha256 cellar: :any_skip_relocation, catalina:       "721dc13ccd8be4f51f100306e79ef3dc43cfa9a736079d4957474196c2370d01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a60ba873b5007323ae82cc9eae2777c308eb31a93b554f946732e0b25f3da46"
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
