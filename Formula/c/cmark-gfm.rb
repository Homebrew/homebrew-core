class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://github.com/github/cmark-gfm/archive/refs/tags/0.29.0.gfm.14.tar.gz"
  version "0.29.0.gfm.14"
  sha256 "1c1acf50c5e9939e170b6e017ec06fcf94abeb383670b819d091a285b7ba11fe"
  license "BSD-2-Clause"
  compatibility_version 2

  bottle do
    manifest_sha256 "51cace98103c54d5e2a85adbab636d54a5ae84f2a19bd81e984be6bf272276d9"
    sha256 cellar: :any, arm64_golden_gate: "ee420d6bd4c2c39c7a07d057c5930ec4e5e748615fafcd3df6f68b280468b6ad"
    sha256 cellar: :any, arm64_tahoe:       "8e64ee0191d7c9d5bc72720bc27e262dd41cb9d9ddc44a47c2315ca86a5888da"
    sha256 cellar: :any, arm64_sequoia:     "f494a64ec5af2ed9a7f367a3061e8a98f2b6c51a1e0a036efca71b6901963ec8"
    sha256 cellar: :any, arm64_linux:       "1d69674fcb1e270ab2c210c645dafed8db6840693cf679087ebbfcf1450204ae"
    sha256 cellar: :any, x86_64_linux:      "836c3602c5e6f005d3bd80000aa857ac6173581f91baa61d01c1059f471762ae"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  deny_network_access!

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end
