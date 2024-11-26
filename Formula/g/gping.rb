class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/refs/tags/gping-v1.18.0.tar.gz"
  sha256 "a76e09619831c0f2bb95f505a92c1332de89c3c43383b4d832a69afcb0fafd4c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d5997b1f711f810ad7ac906979aa8e30935fec0d5be6928709803d6ed1e6927"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66ca9e13796783e00217ecb9df7b16577882d7908f2ad2e17e4d79efd166cf02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddc951ebb3e3bb95cc312aa6e8ee465c1171bef226508a99c2f98c329e6e1c96"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb8e2f91391341fe2e43c4a584021f859b79223f21410f980880c709d0a7f720"
    sha256 cellar: :any_skip_relocation, ventura:       "9a1329f19dfd5c4e49ae9fe894ff501b9d9ed6b06022cb49c75296a4591425ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b3d71c0896cb93022a289d740ed310160ea4e92b5da84d60a1bb15fb40940a6"
  end

  depends_on "pkgconf" => :build
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
