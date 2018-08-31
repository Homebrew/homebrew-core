class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.0/bloaty-1.0.tar.bz2"
  sha256 "e1cf9830ba6c455218fdb50e7a8554ff256da749878acfaf77c032140d7ddde0"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    bin.install buildpath/"bloaty"
  end

  test do
    # Bother. The release tarball doesn't include the tests. Just verify
    # that bloaty can run on itself without crashing.
    system bin/"bloaty", bin/"bloaty"
  end
end
