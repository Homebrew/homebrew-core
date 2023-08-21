class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.13.4.tar.gz"
  sha256 "ca2cd3ca21d7ed0410f3327cf3c1b6db990dfbb5bd2ef0d15f3fb0a1b5fe6ee9"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf80dd4275133ea765c63d1c010dca30edcf1c88c2ffa3781ffdc57885c73fa6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22269bdae3fbc24cbc00958acbd816d070cfbefe7f30adc30ac9ba272e17a0c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da8df063e75c7340d8e717cc91127c042ebcb7a6cd345d2150252fb6e0532b90"
    sha256 cellar: :any_skip_relocation, ventura:        "91bab1360f3899c49ff721b76c0b552dc03aa919a37f10b3087769bdc7a1ae0c"
    sha256 cellar: :any_skip_relocation, monterey:       "4fc223f0349d2203b779f0b5447221a90f44e75278189a1218616a0d331aad2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "effc9974650f1e2271d2204af2b67ef0ee48b179185068d24e782fc43539c6c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6977a7adf5a02a37b710b883a13f7a4accdba3d87aafb1bd9888fdf30d06a1df"
  end

  depends_on "rust" => :build
  depends_on "portaudio"

  uses_from_macos "python" => :build
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
