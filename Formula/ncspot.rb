class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.13.2.tar.gz"
  sha256 "c329fc3fe229c47c2b3490555b4c8df550a3e2bbe3d0ade4e07f59434fa14e77"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "83d6c93fba14b46a2f947e0a7710da83a5032954b1047ff8283550a8da1cd702"
    sha256 cellar: :any,                 arm64_monterey: "d7a8f525e2cea94ed97102f562e518bacbc1fa47a288588da9f5ddc195fe6262"
    sha256 cellar: :any,                 arm64_big_sur:  "82ed36e353fa98b8adeb5c0d69e0d6f90662fff63818719cbe9a01fcafc3eb27"
    sha256 cellar: :any,                 ventura:        "6239dd2705b6cc7d678c0ef53d6e1d16aab0b38654b652d34d06b8deb23a3476"
    sha256 cellar: :any,                 monterey:       "96ee0df948f7dbec0a05fe9d05c1a6f164f35479a6d4b6b16cda6b78c72b1761"
    sha256 cellar: :any,                 big_sur:        "a6c63558a72c602eca2373a8d2ec715ed4403bd98c0a46d01ec8dc2ac97ab9c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e209ce05d46f7a533d15c115e4d1c8f0e26f3dc14c3ef6d5f77ef8783b2e4414"
  end

  depends_on "python@3.11" => :build
  depends_on "rust" => :build
  depends_on "portaudio"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "openssl@3" # Uses Secure Transport on macOS
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
    if OS.mac?
      stdin, stdout, wait_thr = Open3.popen2 "script -q /dev/null"
      stdin.puts "stty rows 80 cols 130"
      stdin.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/ncspot -b ."
      sleep 1
      Process.kill("INT", wait_thr.pid)

      assert_match "Please login to Spotify", stdout.read
    end
  end
end
