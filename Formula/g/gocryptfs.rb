class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.5.4/gocryptfs_v2.5.4_src-deps.tar.gz"
  sha256 "0db47fe41f46d1ff5b3ff4f1cc1088ab324a95af03995348435dcc20a5ff0282"
  license "MIT"
  head "https://github.com/rfjakob/gocryptfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c137949a8fc5af4808d1e42cff1c876aa1da7a1fbb2b734bc68f9c0fb97c8a5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f993e2d85263172c467ad6d18fad384c12e7c0fe3c3c362c314d7c42dcf03cae"
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
