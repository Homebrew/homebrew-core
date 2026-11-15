class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/refs/tags/gping-v1.21.0.tar.gz"
  sha256 "350c091923f67fdc72847e12368b2f207015be200ea1d781bce422a2a884d1c6"
  license "MIT"
  head "https://github.com/orf/gping.git", branch: "main"

  # The GitHub repository has a "latest" release but it can sometimes point to
  # a release like `v1.2.3-post`, `v1.2.3-post2`, etc. We're checking the Git
  # tags because the author of `gping` requested that we omit `post` releases:
  # https://github.com/Homebrew/homebrew-core/pull/66366#discussion_r537339032
  livecheck do
    url :stable
    regex(/^gping[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "20fcfe6677455e589630a9de9fd1e4b8c89bb9f49baacaef6e37300ed0db26b9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "793bbcdfab111fbef18dc6361980e3026d7ef753ab21b94dca43caaa1670e702"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "90472e76aa23d33ae21abc5f119af31ab385cfe3412361e6cf8698fcb16c1a62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "02c57f65adf4cfaa2f92fdfdeadbfa0b9a119b2015e25f3aac1fa805c2dbcaa7"
    sha256 cellar: :any,                 arm64_linux:       "931440b195ea3374f82aa66b52c2e69cc5250a9554b3db136949799d72f08703"
    sha256 cellar: :any,                 x86_64_linux:      "8e7c6d532789ecec2f3eec048fd4462997950592377b1799d5abc7a07eebe7cf"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "iputils"
  end

  conflicts_with "inetutils", because: "both install `gping` binaries"

  # `test do` block pings google.com
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "gping")
    man.install "gping.1"
  end

  test do
    require "pty"
    require "io/console"

    PTY.spawn(bin/"gping", "google.com") do |r, w, _pid|
      r.winsize = [80, 130]
      sleep 10
      w.write "q"

      screenlog = r.read_nonblock(1024)
      # remove ANSI colors
      screenlog.encode!("UTF-8", "binary",
        invalid: :replace,
        undef:   :replace,
        replace: "")
      screenlog.gsub!(/\e\[([;\d]+)?m/, "")

      assert_match "google.com (", screenlog
    end
  end
end
