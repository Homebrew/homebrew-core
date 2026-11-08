class Chawan < Formula
  desc "TUI web browser with CSS, inline image and JavaScript support"
  homepage "https://sr.ht/~bptato/chawan/"
  url "https://git.sr.ht/~bptato/chawan/archive/v0.5.2.tar.gz"
  sha256 "21201936aa3a5ff0117fd55bfa1805ab77647761f4341fd2f77eca15bb66c807"
  license "Unlicense"
  head "https://git.sr.ht/~bptato/chawan", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "aff9eab6a17a31ca2ca4e8accde7f2a00cb41df239a7dcc4722e9423a5684e2c"
    sha256 cellar: :any, arm64_tahoe:       "715d381152f6b436ef22e45328bcca6b707ac3bfcd93590359be5f1e4d11f52c"
    sha256 cellar: :any, arm64_sequoia:     "e53d2e84957a1e267f3f9df832a21b15ca2fb760744d6c05409fc6728a7180b7"
    sha256 cellar: :any, arm64_linux:       "7534a69a8201f5db2ee950ebaebb2405aa73eb224c48e4a0148de76b0d39df1e"
    sha256 cellar: :any, x86_64_linux:      "532d3dd8ad4673b30d51d7e494b02ab4fa177ace33b4c5b5dc0a15896ac96407"
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
