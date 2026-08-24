class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/refs/tags/gping-v1.20.4.tar.gz"
  sha256 "63baad8181b8161ed1f1d9091c1a0e8a7f5a63c5f680c7272d0a164596100e25"
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

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a84a6e00d0cf56256665788cf25d37cc12aec4914dc4f2b5a454be3410986c00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bb597a96151bdcac0d2d4df9c58e793fa0e7b66a442bb2f99c4c25d83690f30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6b04d7f864ab14d631ae2443a6c9b6a18367857c614237bd1e685954b9fe181"
    sha256 cellar: :any_skip_relocation, sonoma:        "99c430a7517e10523ca1c1f94070135ffc353452b3dacb3a6175905f91512068"
    sha256 cellar: :any,                 arm64_linux:   "291d93da352740cc3f845f1265a0e0318622e72697b7839d81a13c59a2deca09"
    sha256 cellar: :any,                 x86_64_linux:  "02eaf5c13a5ed3a950d686c97d2f878762c83a63dbd80cde695e88cbebff2fed"
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
