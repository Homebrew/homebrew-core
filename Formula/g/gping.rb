class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/refs/tags/gping-v1.19.0.tar.gz"
  sha256 "a979c9a8c7a1a540bb48a1e90bb7ad294560bddc16ca977bc8475fb14f20155d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39f6fb5ff80ebed71185f01e1228f50390ed76c40451fc7696bd6b426c81d177"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9ce0bca1083744caba3de2d937aa00a1106913c93ebc2a16a1e40bc9006c329"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ecea45940ab8f0659edb8f61e5e9bb239bc9ce71b8275baecaf18c8b27ae2a29"
    sha256 cellar: :any_skip_relocation, sonoma:        "94b2db03885d870c498358c65469c840a66884a479107a33b900b38f828764e7"
    sha256 cellar: :any_skip_relocation, ventura:       "1137be7cc36b8384767d923bcc4a2977c7fb77ecf96a777ff036aa35a8482c17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d5c6309c3ccd67422b6a4611db1b4d3319c366db24047adc4f3a6ebdaee5081"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "iputils"
  end

  conflicts_with "inetutils", because: "both install `gping` binaries"

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
