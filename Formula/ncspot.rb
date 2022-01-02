class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.9.4.tar.gz"
  sha256 "17c300194de48bba1aa75801ede1d9a3a6e3be473145d8663e3f4360b41361e3"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "56eb06345b59533a1df7447dd2b339ad3840fa756a581368fc29806b3302074c"
    sha256 cellar: :any,                 arm64_big_sur:  "c08f2b2e1db3902b8db6f2a194db6b51d380a54a14969cfb39d4f04823465519"
    sha256 cellar: :any,                 monterey:       "6f0cf2004117915903c1216e65d49df5311204c44b052a74f1be2717d62eb5b4"
    sha256 cellar: :any,                 big_sur:        "ad76409c2661a47f9aad163f4776de1d3f218871cd35c1d4c13bf5a876a13251"
    sha256 cellar: :any,                 catalina:       "d1e1e1e7d827b41a8fc410b6ef0f41a2bff9763dc9645db4bce6f886749540f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e3c2003c42b6876cde3a89a4ab97bb6c74c8ca0d75cd3302e63556adf5979e0"
  end

  depends_on "python@3.10" => :build
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
