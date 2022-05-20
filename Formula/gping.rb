class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/gping-v1.3.1.tar.gz"
  sha256 "ab185e0fa88f9dbc903dbf85b4fda924d9c17341464eda7419e054da70ff846d"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68c0b67cf8499a892299645e69f8e03acb9838100992912d9e521840c88b877f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86fa30946fc356b57d1d6a33b8a15a57020f592d22f62cf4f87b0ccb918a520d"
    sha256 cellar: :any_skip_relocation, monterey:       "b115a4c7dc3153a1b7043a77ecc27394ed22bc3326bac58c50354c22c4de318d"
    sha256 cellar: :any_skip_relocation, big_sur:        "98f9ec00923df1b8594bb1af2208ffa15e6752d65eeb407304a4abe797a525c5"
    sha256 cellar: :any_skip_relocation, catalina:       "fd0a09ed90e7574dc8ae5034fbd9d62e8a2af34566ec22538ca6711a86561d59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ec003d4f3a46a7e8764eb798fa593b2d8588b497c87e271fd14c8c1f5892aa8"
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
