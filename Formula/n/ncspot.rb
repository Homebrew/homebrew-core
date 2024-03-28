class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "d3cd828cebb3e84470f03be16925db566d4dd8289cfd3e230e64278ec9d96338"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bfa7f97a9ecb154fb1ad154970bbd66dbc4c1f016184f55060377477859be58f"
    sha256 cellar: :any,                 arm64_ventura:  "a0add2b26562a8c1fae8f5608dfead732cd42a48a768dbec935cfb859efbd9c7"
    sha256 cellar: :any,                 arm64_monterey: "42a39596a03898c3986b612dd8a3fb569c178a6ab238093c47140199d79ab686"
    sha256 cellar: :any,                 sonoma:         "d9ff24d78fad03ec2723dc7e2ac491346d51d7e0626d8b6c9ae28b7acfd31f6a"
    sha256 cellar: :any,                 ventura:        "d4d26e53ddc8eaa14850f17154a0f51576e98a42f0ef8f8291bbf6a4f5577cdc"
    sha256 cellar: :any,                 monterey:       "a764e345b58d509aad975d4e0a8cfe045f543bf091dc151aea20919a6e89decc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46397c79f0d75b945a30ce38896628d06b850bf0a2046174b84efb910ed8bc97"
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
