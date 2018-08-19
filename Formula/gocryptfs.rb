class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v1.6/gocryptfs_v1.6_src-deps.tar.gz"
  version "1.6"
  sha256 "98ff3bc0497ca195f65fa5912ebab33a0f80aa27205b0b35e73908d23dcefbe6"

  bottle do
    sha256 "5ed1b0476b84d5fe62d55adb39fb994ea1a5b67b4212ae38021aaed40b5c4f93" => :high_sierra
    sha256 "4be626332d816443489e1f7aac91316d2186c56930f8bdd9f78e7f033c427f85" => :sierra
    sha256 "090799ef10c2f9026e9cbe4f235410efd2e35dce5cc8b8005a520f25ce9ae5a9" => :el_capitan
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
