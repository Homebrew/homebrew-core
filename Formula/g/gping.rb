class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/refs/tags/gping-v1.20.1.tar.gz"
  sha256 "0df965111429d5fcef832a4ff23b452a1ec8f683d51ed31ce9b10902c0a18a9c"
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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ea7c7e96a88df4ee9e8cf12a47849a778eabdd015c2c56e0ac1b46dba8b329f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4b724bca246855e7c11aa972489d8a99fff3b1775ee68832ce55b645d219210"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9e5e2357d554380b42514cc043dfca7e24dbd00eed6c49640aa984a5dd8d551"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3825f08e0158e83a76fc27c7103364db82d748010c72f1afb1d607f8aa79fa8"
    sha256 cellar: :any_skip_relocation, sonoma:        "88b15ad904d11c0353fb62c62a0e8aef8cbe054275324d281fcb1c36d2ca4882"
    sha256 cellar: :any_skip_relocation, ventura:       "f042f035aa83f1ac2a29ef5e3f7437fba693a50fb14c939e6b4fc08a9e100f86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a071b10dbf714a17277fc3d007876025e8eeb7ccd8233871cec335845c2b15e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "773e0bb37bb0a63656ad1ff05f8f135054b5bb935440b58936f22726392aef09"
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
