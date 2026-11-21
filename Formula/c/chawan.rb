class Chawan < Formula
  desc "TUI web browser with CSS, inline image and JavaScript support"
  homepage "https://sr.ht/~bptato/chawan/"
  url "https://git.sr.ht/~bptato/chawan/archive/v0.5.3.tar.gz"
  sha256 "f0f287b5aaf32ad3987c85a107bfc3452d4ea21eeac03a9fe7286a00f4b101f1"
  license "Unlicense"
  head "https://git.sr.ht/~bptato/chawan", branch: "master"

  bottle do
    manifest_sha256 "d70f6fdd06225edfe64fb674966482976ee71eea3bf3f007cc20824bd6e202a3"
    sha256 cellar: :any, arm64_golden_gate: "bb3f748401df1fa3805bfee6f2bedc9c356ff58c38790ec77b667d9b58504061"
    sha256 cellar: :any, arm64_tahoe:       "664de7e0fd3876ecb7d09eb56b60c6aa39f2c3927aa149af2a78285dec5244ec"
    sha256 cellar: :any, arm64_sequoia:     "a11c90959dba18a039c91c487beed90ef66082056aefdf02dde304e753d8ac2e"
    sha256 cellar: :any, arm64_linux:       "eae515e051a4835faa871273472e4d31597b4fbbcc5910fdfc9f2b822adc363f"
    sha256 cellar: :any, x86_64_linux:      "803334e1e57a7908cf99f47ec4b2a54601bb275acaa70f9ff3aff59d5e9e2c0a"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build

  depends_on "brotli"
  depends_on "libssh2"
  depends_on "openssl@4"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  deny_network_access!

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cha --version")

    (testpath/"index.html").write("<h1>Hello, Homebrew!</h1>")
    assert_equal "Hello, Homebrew!", shell_output("#{bin}/cha --dump #{testpath}/index.html").strip
  end
end
