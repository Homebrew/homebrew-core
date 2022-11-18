class Afuse < Formula
  desc "Automounting file system implemented in userspace with FUSE"
  homepage "https://github.com/pcarrier/afuse/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/afuse/afuse-0.4.1.tar.gz"
  sha256 "c6e0555a65d42d3782e0734198bbebd22486386e29cb00047bc43c3eb726dca8"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4bd4dbb3bcc5634a41c6f6332e6f77dbb4404fc7545d53479e309a77613f17ad"
  end

  depends_on "pkg-config" => :build
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "FUSE library version", pipe_output("#{bin}/afuse --version 2>&1")
  end
end
