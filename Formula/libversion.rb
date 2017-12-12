class Libversion < Formula
  desc "Advanced version string comparison library"
  homepage "https://github.com/repology/libversion"
  url "https://github.com/repology/libversion/archive/2.3.0.tar.gz"
  sha256 "f3cec57233c14173a45a801b97e9cf305c96656ac55aa8e15d91d4be29a4273d"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "=", shell_output("#{bin}/version_compare 1.0 1.0.0")
  end
end
