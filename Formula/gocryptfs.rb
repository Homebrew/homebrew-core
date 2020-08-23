class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v1.8.0/gocryptfs_v1.8.0_src-deps.tar.gz"
  sha256 "c4ca576c2a47f0ed395b96f70fb58fc8f7b4beced8ae67e356eeed6898f8352a"
  license "MIT"

  bottle do
    cellar :any
    sha256 "adf2a34cc99f353992e790c856971e9128d55caf5c51a2ae0a50ff5506e63c1c" => :catalina
    sha256 "3e4cd09514efbd074f41f6636f0df0b01708856446c1da1d6cfe766cd8cae121" => :mojave
    sha256 "a7e6b3d28c3e3cd78ff4be78adc8d2feeb8061c7459d2c8e6f04e61f0029bb51" => :high_sierra
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
