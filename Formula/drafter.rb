class Drafter < Formula
  desc "Native C/C++ API Blueprint Parser"
  homepage "https://apiblueprint.org/"
  url "https://github.com/apiaryio/drafter/releases/download/v5.0.0/drafter-5.0.0.tar.gz"
  sha256 "a35894a8f4de8b9ead216056b6a77c8c03a4156b6a6e7eae46d9e11d116a748e"
  license "MIT"
  head "https://github.com/apiaryio/drafter.git"

  bottle do
    cellar :any
    sha256 "29fa18ff148f6ebf454ed383181384bfb9aff1520e64072dfb386445bf8e52a3" => :catalina
    sha256 "2a56e75e39f7b46eba355ae6163b645e161c4e458a4f127c37a948377143ac3e" => :mojave
    sha256 "125fb907888693fd3d638a79d185483f44112f5bb64f098626aa17f00b25513d" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "drafter"
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
