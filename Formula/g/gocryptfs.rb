class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.5.3/gocryptfs_v2.5.3_src-deps.tar.gz"
  sha256 "4b6d874b5383be5ed33d7ef7a5a6152d2b6a5d1965215a426ec855c043138ee2"
  license "MIT"
  head "https://github.com/rfjakob/gocryptfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "ecd1d66396da4bda9894335bc57c7827e06703025654326db99e174a24101438"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "26a541331bfa8f7ba51f14f07c97efaec13171cc88515e217d559eafdccd132d"
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
