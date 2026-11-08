class Chawan < Formula
  desc "TUI web browser with CSS, inline image and JavaScript support"
  homepage "https://sr.ht/~bptato/chawan/"
  url "https://git.sr.ht/~bptato/chawan/archive/v0.5.2.tar.gz"
  sha256 "21201936aa3a5ff0117fd55bfa1805ab77647761f4341fd2f77eca15bb66c807"
  license "Unlicense"
  head "https://git.sr.ht/~bptato/chawan", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8d7012cea4f4de35062af9b6b911567612c6e9dac2f760e3448487690e9b161a"
    sha256 cellar: :any, arm64_tahoe:       "45c110d2af487d402c9fcda873bb30365a79237d58d02e3ae82a174bee1e3754"
    sha256 cellar: :any, arm64_sequoia:     "0ddf2c1740e85f0b9d5ab55cd898f283f7b1d116a6e303ea5e99e37bda5ed775"
    sha256 cellar: :any, arm64_linux:       "c6540b38307bfa48527bd440798dfdb796fb78387d3d35ce5bd93e4271ad6d77"
    sha256 cellar: :any, x86_64_linux:      "f51f142e82544ba5ba0aab91701567a1aa18ec249f0cb0fc25c146081a64959b"
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
