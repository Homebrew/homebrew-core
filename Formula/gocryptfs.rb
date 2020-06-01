class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v1.8.0/gocryptfs_v1.8.0_src-deps.tar.gz"
  sha256 "c4ca576c2a47f0ed395b96f70fb58fc8f7b4beced8ae67e356eeed6898f8352a"

  bottle do
    cellar :any
    sha256 "4dc5577b1e78ef922d534275cd5024ec83365a412e9c766f46b5ee4aa6a3bf4c" => :catalina
    sha256 "c864ef84c22ddd708c54542fa2e52b2a85fb337717edf83e00e45f608ac5e736" => :mojave
    sha256 "92d21f9d17aa19aa59592549675857f103af7ffe211485ac7c7e900f09a32813" => :high_sierra
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
