class Drafter < Formula
  desc "Native C/C++ API Blueprint Parser"
  homepage "https://apiblueprint.org/"
  url "https://github.com/apiaryio/drafter/releases/download/v4.0.0/drafter-4.0.0.tar.gz"
  sha256 "f284cddf24c321947f85c21e5b27500e876f0181d91eda7d96b3350b48533139"
  head "https://github.com/apiaryio/drafter.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c575d7ee71067b22065599f8f0cd345342b3da1e3035b1cff7219125a981cf0" => :mojave
    sha256 "3d5b2efca1959e624da8780d126eccb055ef7781df09fe2531f69aedf9868c65" => :high_sierra
    sha256 "6b45ff8ad9096b321a6c386fbca3176a53b45af4c9544b8cde4dc57db63c85dc" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "drafter", "drafter-cli"
    system "make", "install"
  end

  test do
    (testpath/"api.apib").write <<~EOS
      # Homebrew API [/brew]

      ## Retrieve All Formula [GET /Formula]
      + Response 200 (application/json)
        + Attributes (array)
    EOS
    assert_equal "OK.", shell_output("#{bin}/drafter -l api.apib 2>&1").strip
  end
end
