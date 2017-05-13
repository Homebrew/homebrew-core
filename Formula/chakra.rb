class Chakra < Formula
  desc "The core part of the Chakra JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.4.3.tar.gz"
  sha256 "b0f6d626f3c895428947d5b67e90e5965c032e21689dc8d6c326a697e859980b"

  bottle do
    cellar :any_skip_relocation
    sha256 "72d7c085dc79436b38dc68294fbf56df46c9c50a63e78b091b93d090095695a9" => :sierra
    sha256 "0ce8a0fd230d2ed7e864ebb25b55691e43bf8318ef227efd54dd911b11edc4dc" => :el_capitan
    sha256 "4f3cd4770c599e8caff5361d588e41c3cefbd5f6f0e6d23c1a9e9fc3cce1c8b6" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "icu4c" => :optional

  def install
    # Build fails with -Os default
    # Upstream issue from 26 Jan 2016 https://github.com/Microsoft/ChakraCore/issues/2417
    # Fixed in master https://github.com/obastemur/ChakraCore/commit/cda81f4
    ENV.O3

    args = ["--static"]
    if build.with? "icu4c"
      args << "--icu=#{Formula["icu4c"].opt_include}"
    else
      args << "--no-icu"
    end
    system "./build.sh", *args

    bin.install "BuildLinux/Release/ch" => "chakra"
  end

  test do
    (testpath/"test.js").write("print('Hello world!');\n")
    assert_equal "Hello world!", shell_output("#{bin}/chakra test.js").chomp
  end
end
