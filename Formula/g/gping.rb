class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/refs/tags/gping-v1.17.3.tar.gz"
  sha256 "bed3e1d46c2311ae15cad114700458a138e7d29fd45322cb9dd2c1108eb5a68e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6e8b08ac653ce93370c85ac653ec29740ff21eb5749e412b1d942f7acee8054b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6eb418ec57e33d1bfcfda69a0738e5e164de6a1d197849dbde6da4c63756d91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f959a7aa732520112d44a85bc11012239ceb3e275a8dcf46ecc19b464caf5e0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b48ca5b370e8eb0f569d4f21e6663da95d2a0de3ed734a3e8b1e3177d258590"
    sha256 cellar: :any_skip_relocation, sonoma:         "9aa68b0f94c94e6427408eb1f1f529ffcb834a03d89b6d903e252be94b53a886"
    sha256 cellar: :any_skip_relocation, ventura:        "de2141acb5076142902729d31b6e61355cb881c31a4d5a66f2865436f70a3788"
    sha256 cellar: :any_skip_relocation, monterey:       "fec4f74efb785001b2c963521c08112ad4f783aab0f1c2aeb9cfb00371577bf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4bb666c77ecb5e01cb365cef6e6064f75c136bebb4aa0a9786893dc9a9edc28"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "iputils"
  end

  conflicts_with "inetutils", because: "both install `gping` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "gping")
  end

  test do
    require "pty"
    require "io/console"

    r, w, = PTY.spawn("#{bin}/gping google.com")
    r.winsize = [80, 130]
    sleep 10
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
  end
end
