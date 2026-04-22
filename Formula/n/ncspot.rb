class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "26edf6f1861828452355d614349c0a2af49113b392d7cd52290ea7f180f6bfe5"
  license "BSD-2-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00faf4c71b398817e3e68dbe86b65d65ef9cd44e7816b63b61cdc356dd892ad9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e88de47e8ff48e7b7b628747113d1e8feb148b1c423c8349ed615498d8407c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0ae333c7953cfe9cb1a156c3472aa85f7a45d8f3e106e26d7b405fab390e8ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae62b1f8e28527e476616d9f8cd5620df0ca893b067224f47687dab12ff0dc02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bb3f059bf0f44ac9e0ea9582adf9663833105df7ad5b48011fa4ccaa2bb37f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ebde50fa8eaef19ca9ab59b16012072136046bdcecb3f005e1f39b3eaa24261"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
    depends_on "pulseaudio"
  end

  def install
    if OS.mac?
      ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path
      args = %w[--no-default-features]
      features = %w[rodio_backend cursive/pancurses-backend share_clipboard]
    end
    system "cargo", "install", *args, *std_cargo_args(features:)
  end

  test do
    backend = OS.mac? ? "rodio" : "pulseaudio"
    assert_match version.to_s, shell_output("#{bin}/ncspot --version")
    assert_match backend, shell_output("#{bin}/ncspot --help")

    # Linux CI has an issue running `script`-based testcases
    if OS.mac?
      stdin, stdout, wait_thr = Open3.popen2 "script -q /dev/null"
      stdin.puts "stty rows 80 cols 130"
      stdin.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/ncspot -b ."
      sleep 1
      Process.kill("INT", wait_thr.pid)

      assert_match "To login you need to perform OAuth2 authorization", stdout.read
    end
  end
end
