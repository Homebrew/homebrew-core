class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.5.1/gocryptfs_v2.5.1_src-deps.tar.gz"
  sha256 "80c3771c9f7e65af9326b107ddb7a30e9c3c7bf8823412b9615b7f77352cdde7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "096b61cbe7361464b940953a7178a6c3df234e15975876a61a88e051456dde6a"
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
