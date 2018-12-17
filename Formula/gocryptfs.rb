class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v1.6.1/gocryptfs_v1.6.1_src-deps.tar.gz"
  version "1.6.1"
  sha256 "fcaaf59cf7b062a6e216d2fcf69f374254018a9b8f99ae3177ac985f05b6c37b"

  bottle do
    cellar :any
    sha256 "96e71183005e7af0dfbf3efc661c4b4a4d85012021b7728ca39b6b788e38ff38" => :mojave
    sha256 "7fd1eb2fe49336859391b3f4e737873560d883c3ad216e09a9cd881417a1fd26" => :high_sierra
    sha256 "746cc85d6ab7a6b711c82dd4b49a578fa61186abc980dbf5a341f08252b464b7" => :sierra
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
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
