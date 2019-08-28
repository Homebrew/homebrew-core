class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v1.7/gocryptfs_v1.7_src-deps.tar.gz"
  version "1.7"
  sha256 "2d1a2cfd072d554a28ee6e6807474b00ac710fb1aaf7aa81f3d8e94e80f6a703"
  revision 1

  bottle do
    cellar :any
    sha256 "8d6983f1264b86e94e945a5e9577c5b79cb7488d4e8cbd717d6fa0c705d5e5e0" => :mojave
    sha256 "f5e8c9ef52adee8a36f8d3068426db475ad5c836d4119ad96ca33df19c69b774" => :high_sierra
    sha256 "32490efe5a1080007c61c664eb952c5114c717162547ce32fcffb823abe700e1" => :sierra
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on :osxfuse

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rfjakob/gocryptfs").install buildpath.children
    cd "src/github.com/rfjakob/gocryptfs" do
      system "./build.bash"
      bin.install "gocryptfs"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"encdir").mkpath
    pipe_output("#{bin}/gocryptfs -init #{testpath}/encdir", "password", 0)
    assert_predicate testpath/"encdir/gocryptfs.conf", :exist?
  end
end
