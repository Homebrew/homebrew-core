class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "89fd70d625304ad882f2b3fcd048ea0e3910a7df371f942feded2ec57b4012b4"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "481c93cb39877140500a98a4244f8070dd32a1d363d9c4812f21cfef4c437956"
    sha256 cellar: :any,                 arm64_ventura:  "cc292ee5bcd009be06c1d5ae06b956a0c7fb49540653f2a2f5e9eeede251401e"
    sha256 cellar: :any,                 arm64_monterey: "145cb41ad2cd223d8d18b484c0aca96638a4b13a3e4fe332ff2eca50d16b2511"
    sha256 cellar: :any,                 sonoma:         "17055ed02f712e70225ab9163c885a2c84bf260ccbea4354e53562d0065fd48f"
    sha256 cellar: :any,                 ventura:        "2abb599c2aa9d2c4af608ab3663aa227ce99cc34f6f00564ef09264ce73c083e"
    sha256 cellar: :any,                 monterey:       "0abc3a1a7098006eb881528c6a2850c0e92dca9108253aa083ee2ffe7fe84613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0eeff1893a1cd87c42ab9db11d8f3e696faa5bc9ca144acb381cfb4a006cad2"
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
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed if OS.mac?
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
