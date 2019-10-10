class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v1.7.1/gocryptfs_v1.7.1_src-deps.tar.gz"
  version "1.7.1"
  sha256 "d3fc2c87b869025cd51e4abea030e58e7383197a7458f26bf99a71b224402bda"

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
