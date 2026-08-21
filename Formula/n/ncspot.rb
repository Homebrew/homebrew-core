class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "fef88f9d9062102ab2d234c8402bfab52181b4c4d892c149f1ae5eefa6182345"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c932922e219318296220c0e73fcdd1cc8231cf394f74e6e912731873e52d14a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e73cb974f9a767f19620ac49b494946c4d158097b03ec72e7b06d71004a139f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72a294a741196177a7a7a5663d0240b23d72b6287611532eba27364b491dd2b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dd30dedb8c57ac5221d1e5ec19c6c1ccf7e759d033d10d1eb03d296f4526747"
    sha256 cellar: :any,                 arm64_linux:   "ecc68590eceedde232dd341536f8977245dade87cf21c95dd06f5b33682bef6a"
    sha256 cellar: :any,                 x86_64_linux:  "21b7c64e7d8c4ae7de59e90ba93e5ae9f6659a9397c08db2a53f5292451bdada"
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
