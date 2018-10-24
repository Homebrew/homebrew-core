class Afuse < Formula
  desc "Automounting file system implemented in userspace with FUSE"
  homepage "https://github.com/pcarrier/afuse/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/afuse/afuse-0.4.1.tar.gz"
  sha256 "c6e0555a65d42d3782e0734198bbebd22486386e29cb00047bc43c3eb726dca8"

  bottle do
    cellar :any
    sha256 "d28d229c3bc7317681e538388a3d87df170aa56dc8e5e9ced6bf964e6fafba71" => :mojave
    sha256 "5596df8a8351206809f4b047e9d357e36273f5d505e531db3f14d320cf7eec28" => :high_sierra
    sha256 "900e55a47834181f518e87e7cbaaf0f3f078b0d40631ffccfc776e82c7c61f87" => :sierra
    sha256 "a4c0f86a179ca8c5d1e3977ff167dbcd1abff4ec1ee17fd5700a3fb602c781a3" => :el_capitan
    sha256 "2a57c7752c7b461f6b628a1c30e845fe13685eab394d933e8da3aebf7102ae9c" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on :osxfuse

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /OSXFUSE/, pipe_output("#{bin}/afuse --version 2>&1")
  end
end
