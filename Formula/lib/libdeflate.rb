class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/refs/tags/v1.25.tar.gz"
  sha256 "d11473c1ad4c57d874695e8026865e38b47116bbcb872bfc622ec8f37a86017d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bac15aaf2c6c274e7015f543a3ea80cfcafd16ffae196c71d91b3e490156a9c9"
    sha256 cellar: :any,                 arm64_sequoia: "81bb3537257061a0a60cf1b6842b7c13d9090ddce9bd8ec84fa7381e08c45b47"
    sha256 cellar: :any,                 arm64_sonoma:  "6a2cab5c8f45cec6f2df4ceae582183ecaa7624c9857d13a2daa5078f5ae09a4"
    sha256 cellar: :any,                 sonoma:        "89347badfd54cb48639e530a51d86cf3c83d946740dc90519460bac0271270c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d50f2f720c56c25d13111d2a54c4b0d8600ad89dbe4703319ec4196df988aa60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b498b36ecd45eae8f0f1b84366ec1e82b996d037610ee0006ae384233b4a4bb"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"foo").write "test"
    system bin/"libdeflate-gzip", "foo"
    system bin/"libdeflate-gunzip", "-d", "foo.gz"
    assert_equal "test", (testpath/"foo").read
  end
end
