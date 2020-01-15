class Drafter < Formula
  desc "Native C/C++ API Blueprint Parser"
  homepage "https://apiblueprint.org/"
  url "https://github.com/apiaryio/drafter/releases/download/v4.1.0/drafter-4.1.0.tar.gz"
  sha256 "243032f9ff202bffdc10b382a435f59b0110be8da1029f8c4208b8c22bd37f06"
  head "https://github.com/apiaryio/drafter.git"

  bottle do
    cellar :any
    sha256 "4cbb74b2c3398833b374c27fe5490386239ff6717436a1737def8b20d9e74ae9" => :catalina
    sha256 "333b8f9b68f883f9aa75b96ec2547b5149bcf6e963f03f06d38c262e180ff503" => :mojave
    sha256 "36c0c14b26b458caa49e41e20d6005a5fbbdac577d3ae80b1ed417ab5625975e" => :high_sierra
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
