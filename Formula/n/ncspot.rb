class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "93c4448b2c027c08c02295b2ffb1a48b684b65100cf4730b1dc9ae35afe06ea6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1234012ea21d77486a0ddce6007669f710003038e9c93d2f0e08d3124d7f33fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "118b4b02eee0ad5070cf999e2be90f790f719ae35c453080318df0124f1f8512"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52d7093d0f3b50e5a3fed555158ef87ec6020f846afe5b796fe58bb8e5bd764d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a66efa6d37ca5b0ec83f90175492dbbfa7e39ac984766d1249ebea1f06b6589"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d767d9686ce12ff08bf0a05d7e8b0d12c4db70ce9a93277de3b1476982fbf1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f07992f959c8dbe462bc91b733881547ab0458f870ddf0894f4a75f1d4362ba3"
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
