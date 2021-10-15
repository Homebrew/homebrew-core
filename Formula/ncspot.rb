class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.9.0.tar.gz"
  sha256 "81655d9fab4903c6ac22321f1a6801aaedfbd88d4f5f768ae8303104fa904a53"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "006908520bb2b297ab38570481fd5b2d51a2668549977ae800a9a2d2ad1ff77b"
    sha256 cellar: :any,                 big_sur:       "05255511d98f0726723947f1ece3a6ea0bc489a19d39deff5d93729ce6462e6a"
    sha256 cellar: :any,                 catalina:      "e8ba2b94588303c1cdf4719b9f9470a89a8d4b235f9cb3aea32f3376dbc8fb6b"
    sha256 cellar: :any,                 mojave:        "28aae6e35fe7d5749ab7b2d81d4905e85f821ad97c565e8ab10b2da8f401f545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acfb22cd6fb3be1ca6f1d01bd30b376ca86993ff89c57a981ed43df101bcf905"
  end

  depends_on "python@3.9" => :build
  depends_on "rust" => :build
  depends_on "portaudio"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
  end

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed
    system "cargo", "install", "--no-default-features",
                               "--features", "portaudio_backend,cursive/pancurses-backend,share_clipboard",
                               *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncspot --version")
    assert_match "portaudio", shell_output("#{bin}/ncspot --help")

    # Linux CI has an issue running `script`-based testcases
    on_macos do
      stdin, stdout, wait_thr = Open3.popen2 "script -q /dev/null"
      stdin.puts "stty rows 80 cols 130"
      stdin.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/ncspot -b ."
      sleep 1
      Process.kill("INT", wait_thr.pid)

      assert_match "Please login to Spotify", stdout.read
    end
  end
end
