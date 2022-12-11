class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/gping-v1.6.0.tar.gz"
  sha256 "88cbbdf6aa1844a7eb6f6bce2de4cec52ef6417643c37948cfa37e38e76e2847"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77f4a2c81aaff2e48dd451146a05a16c93abc677e39cc6ac8cb6b0ec8631bd90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb741f7cb13b9dcaabc8997bf18e9dec598e6fa4147828029b366074383c8304"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56634bc0cae663992557dfb29f0f8f318a0992b273aafe622dd7631ad9eb8238"
    sha256 cellar: :any_skip_relocation, ventura:        "4f5cc8d706bdece5f797a1fa6d904bef62281e9d944107a13d7c476c324db712"
    sha256 cellar: :any_skip_relocation, monterey:       "84c430d57cee9981a04603b497fc7eb7235314f8af56d10130b077baca948857"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0f84cf32d7ffda2b321b4c79c0be8c499dcf85fc9a32d7e53b7fc50947d8efb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd175ce7e9ae7cbc16de88032cff76eba7ae6ba5e52842d610b46e5413c0daf8"
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
