class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.6.1/gocryptfs_v2.6.1_src-deps.tar.gz"
  sha256 "9a966c1340a1a1d92073091643687b1205c46b57017c5da2bf7e97e3f5729a5a"
  license "MIT"
  head "https://github.com/rfjakob/gocryptfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "0dcfa87911d05b4bcc751d9a15b6aefd1b2876499c7f1f9eed58a9af84b891dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "689397d13f30daf5630dcb4ee457a6a2ca1d77100a23d9dd4a40c1f31840a2b0"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@3"

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
