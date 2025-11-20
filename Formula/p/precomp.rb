class Precomp < Formula
  desc "Command-line precompressor to achieve better compression"
  homepage "http://schnaader.info/precomp.php"
  url "https://github.com/schnaader/precomp-cpp/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "b4064f9a18b9885e574c274f93d73d8a4e7f2bbd9e959beaa773f2e61292fb2b"
  license "Apache-2.0"
  head "https://github.com/schnaader/precomp-cpp.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "37a2fbc9d8ef7f210168e5c4f2a3ce13944482c26207fb06ed6cec0138464395"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e17e36888fa003ff01ce0af6dd634576f21c2f303cea989f507730c95af6f827"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac582dec76b87c1affdf3a0065385f587b7fb47a3c7bdecd391a0e067fbcbf1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33c0801e82dd120a4300a93190e59d99da46d28acb0cef6f6946ec9a75cad1e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5567c2d4a2a3e18046d75f916742f0d112c81c2c744e63aabfaa0f75bb3ab0a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "527a77954282f384fd4bd01ec67750d73ee5fc0d989cee4be22ba688a461a90f"
    sha256 cellar: :any_skip_relocation, sonoma:         "be2cd21d5897846900b73dd4e6677cbf0f5e58d488d41115dd74548866f6401e"
    sha256 cellar: :any_skip_relocation, ventura:        "77b3e5aedbb4e12c3ded5f546045d04e8cecadcc2c5a4700299ffad6be3912b2"
    sha256 cellar: :any_skip_relocation, monterey:       "d7b2be3194f675f7db87d9952635a1f0bcb36b2b4cffdc63078d1adf8683bc63"
    sha256 cellar: :any_skip_relocation, big_sur:        "98d1f2f0987f9317b372895c3af39358585a461023e286baf2ebc67d118cf3be"
    sha256 cellar: :any_skip_relocation, catalina:       "9ac9f156315ae463a1e378bdd9ed06d5f36437ccff4505740dfa10ee914b5adf"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "94d7a49395b7ea41b35d5ba993dc244fa2dd0795f300bc27b2f94821047daba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7affc5c732e89618e28cbdc3a5b93adfd8588fe0af291dde9c940b0667ea8c06"
  end

  depends_on "cmake" => :build

  def install
    # https://github.com/schnaader/precomp-cpp/pull/146
    inreplace "contrib/liblzma/rangecoder/range_encoder.h", "#include \"price.h\"",
              "#include \"price.h\"\n#include <assert.h>"

    # Workaround for CMake 4 compatibility
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/precomp"
  end

  test do
    cp bin/"precomp", testpath/"precomp"
    system "gzip", "-1", testpath/"precomp"

    system bin/"precomp", testpath/"precomp.gz"
    rm testpath/"precomp.gz", force: true
    system bin/"precomp", "-r", testpath/"precomp.pcf"
    system "gzip", "-d", testpath/"precomp.gz"
  end
end
