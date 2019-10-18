class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://github.com/github/cmark-gfm/archive/0.29.0.gfm.0.tar.gz"
  version "0.29.0.gfm.0"
  sha256 "6a94aeaa59a583fadcbf28de81dea8641b3f56d935dda5b2447a3c8df6c95fea"

  bottle do
    cellar :any
    sha256 "f318b456ed27ff10c495df41c9aed0208761e9fb10b43905d37a39ae30321cf0" => :catalina
    sha256 "82cf0b26777bb839ace2b833e5390c17f5e4da1e91f61c8729f084e3bac4063c" => :mojave
    sha256 "b816bbd9cf54cca8146e55cb9920fe8bb182599d4e0157582d39f6ab3b16d999" => :high_sierra
    sha256 "2f5538c985404d43a128b7ae61ae93c4c4a9c9d277fa14e28cf1f729c0337221" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "python" => :build

  conflicts_with "cmark", :because => "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end
