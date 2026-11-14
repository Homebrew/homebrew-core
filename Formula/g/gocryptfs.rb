class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.7.0/gocryptfs_v2.7.0_src-deps.tar.gz"
  sha256 "52a271a12bcab3b2e51c0e7baa53a2beeebc9f811d8b28d6b23662a2b70e5680"
  license "MIT"
  head "https://github.com/rfjakob/gocryptfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "d1f8101253e8aa15a57900c0f6659a82bf0408068e85dd31baf6c173540428ed"
    sha256 cellar: :any,                 x86_64_linux: "690b48f7f2fdadb0e601a3ea2e32b121683f0c545f3093bd92b1053cbecb934a"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@4"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "./build.bash"
    bin.install "gocryptfs", "gocryptfs-xray/gocryptfs-xray"
    man1.install "Documentation/gocryptfs.1", "Documentation/gocryptfs-xray.1"
  end

  test do
    (testpath/"encdir").mkpath
    pipe_output("#{bin}/gocryptfs -init #{testpath}/encdir", "password", 0)
    assert_path_exists testpath/"encdir/gocryptfs.conf"
  end
end
