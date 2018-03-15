class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v1.4.3/gocryptfs_v1.4.3_src-deps.tar.gz"
  version "1.4.3"
  sha256 "adf55824fd6ca8e258e9207217c52206953293c6ff86e68b58874b6d195e5b11"

  bottle do
    sha256 "e78575f894959fc13b4a30e01a9f8fdb22d4774ee1d3b69293842f0f3a9593cf" => :high_sierra
    sha256 "a172e3b1016cf339d46cb78b18a0fe0b1a1bd08fc2ec991bce9a5798b4d9ecaf" => :sierra
    sha256 "6b59252b280b9dfa60bb0437cebf4ef6d1bdea4d333e22becb76ed63ffcbe545" => :el_capitan
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
