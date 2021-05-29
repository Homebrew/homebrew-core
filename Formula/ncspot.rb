class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.7.2.tar.gz"
  sha256 "5fc9a50d112e37cb2117f4742ea71aa45ce247d620db62d35dafd175c6a5d754"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2b7eb1a8ca078a4fcc7c82ff6f45dc473c7a2e195bba36d0c106f4e36639942f"
    sha256 cellar: :any, big_sur:       "1e24de89701b9a3f8472f0d5be8ea9163894654f3f5495f54b88956505c03752"
    sha256 cellar: :any, catalina:      "6a9d37eca603aa14c7f567851f104db6c36793edcd9f1d452e94401721f698ef"
    sha256 cellar: :any, mojave:        "a3315bf1170dcea0fdc9e0cadac6793f78f6b6663622dbe01a19636e80459878"
  end

  depends_on "python@3.9" => :build
  depends_on "rust" => :build
  depends_on "portaudio"

  on_linux do
    depends_on "alsa-lib"
    depends_on "pkg-config"
  end

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed
    system "cargo", "install",
      "--no-default-features", "--features", "portaudio_backend,cursive/pancurses-backend", *std_cargo_args
  end

  test do
    stdin, stdout, wait_thr = Open3.popen2 "script -q /dev/null"
    stdin.puts "stty rows 80 cols 130"
    stdin.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/ncspot -b ."
    sleep 1
    Process.kill("INT", wait_thr.pid)

    assert_match "Please login to Spotify", stdout.read
  end
end
