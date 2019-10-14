class Drafter < Formula
  desc "Native C/C++ API Blueprint Parser"
  homepage "https://apiblueprint.org/"
  url "https://github.com/apiaryio/drafter/releases/download/v4.0.1/drafter-4.0.1.tar.gz"
  sha256 "cd166b86c04552be922f9276f77337f36f0d079b0d9b16fdd7ea776448846be6"
  head "https://github.com/apiaryio/drafter.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "97e1f9191bbe558864b1a4309f14d45a8a8d7aa0690e8d939c28a11cef29d137" => :catalina
    sha256 "d6d5e71be65026821d414de415e42f9280df044083871dac2b442df53c2a66cd" => :mojave
    sha256 "ddcf22610fe9e8319171ab69dc7967d6abd9e45a9d2fc26560b61742c7494f67" => :high_sierra
    sha256 "e42d719fd9d05f0f87e75be262d09b414aafa5484cf3552aad8a50d14fe985ac" => :sierra
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
