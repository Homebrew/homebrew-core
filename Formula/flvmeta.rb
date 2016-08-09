class Flvmeta < Formula
  desc "Manipulate Adobe flash video files (FLV)"
  homepage "https://www.flvmeta.com/"
  url "https://www.flvmeta.com/download.php?file=flvmeta-1.2.1.tar.gz"
  sha256 "4b48afc2db8b0ff1c86861bc09a58481bc241d93b879b6f915fbf695fc4bff51"
  head "https://github.com/noirotm/flvmeta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "96ff719e9372c5540d1984a25ab9d83d7b705a73869c7290a9fb2875b7621d31" => :el_capitan
    sha256 "adb6beea407cce7d7613b6913c325a32c35fa61bafd60f7fd128ac9dada7a90c" => :yosemite
    sha256 "5c0e1981d636f596b82be130ecff9d722e3f5f92b1f484b649b5bb6d78200742" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"flvmeta", "-V"
  end
end
