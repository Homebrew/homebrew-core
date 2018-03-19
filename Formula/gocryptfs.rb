class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v1.4.4/gocryptfs_v1.4.4_src-deps.tar.gz"
  version "1.4.4"
  sha256 "988258acd8c4105ebd660b1a411e1174d803f3765c4dc2721c8512356cbe3f3f"

  bottle do
    sha256 "54e85a214d7f742c94f56c8726f2816e7fb5b5ff99ba318d9dd2a376adbdcd3b" => :high_sierra
    sha256 "5ca878be5f42a65443d66ca1d41c0afc9ed59659fb0e8cb8c283e2da075cfcc3" => :sierra
    sha256 "c5a6df44dd33df0f2962b3fdeb7a872bb9562c203279334a74eae3efdd224a2b" => :el_capitan
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
