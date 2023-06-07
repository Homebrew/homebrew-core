class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.3.2/gocryptfs_v2.3.2_src-deps.tar.gz"
  sha256 "2641145d5adfd259959b1fd7b182b61d0ce2ce3e24361b8f3e69fd3f6caa73cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4d9849b9548eba5b03f2a50164d33c5cb14e0734471b3f30a3ff6839ec98fc82"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
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
    assert_predicate testpath/"encdir/gocryptfs.conf", :exist?
  end
end
