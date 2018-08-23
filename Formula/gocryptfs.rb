class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v1.6/gocryptfs_v1.6_src-deps.tar.gz"
  version "1.6"
  sha256 "98ff3bc0497ca195f65fa5912ebab33a0f80aa27205b0b35e73908d23dcefbe6"

  bottle do
    sha256 "469f801ad3ce794b6d767857bc21e6222d7a29a1bd166f105533dbd376eee719" => :mojave
    sha256 "f98594b49df6d4912f50b5c5509d9e5be845e29b81e9638489460702a68eb1b1" => :high_sierra
    sha256 "57378b7bd53f5f5305869d0208a1787b72367bac65226794fde1385cf7841643" => :sierra
    sha256 "a0f5dff1c83b5b6906d24b6de9dba72d4a9d3dde641987d95b0233fa86ac8c91" => :el_capitan
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
