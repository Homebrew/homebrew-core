class Minizign < Formula
  desc "Minisign reimplemented in Zig"
  homepage "https://github.com/jedisct1/zig-minisign"
  url "https://github.com/jedisct1/zig-minisign/archive/refs/tags/0.1.7.tar.gz"
  sha256 "e0358f68a5fe6573c7e735db45cd1b697abcef6925c922abddc20978cd20a9f1"
  license "ISC"
  head "https://github.com/jedisct1/zig-minisign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a349db551b3508819e74a44d4a429f9ffd0bc12b93331a3a305c0efbf17a34d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3520b2254e1d0f5e9096961e925746b2ba4e825ededb7ca0e879be5006d3e77f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c959ed56c57e4b9ac4f9d76ac3fe4f6f39d2d5186f3f7b7f02e75b920f6f095"
    sha256 cellar: :any_skip_relocation, sonoma:        "af5f32f6bce23feaf291f5b3ad22ab4b4a0e4a9d2f9b012b6c0a9e98204add79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbfa1168118d9f119e205f38e1093c50508fe4849e9174ea09408b330cfacc13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc703647a481bb360cd6413e1e926898dcc6b7cad9bcf8ae02f139b3afee7f1e"
  end

  depends_on "zig" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else Hardware.oldest_cpu
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args, *std_zig_args
  end

  test do
    # Generate a test key pair with an empty password
    pipe_output("#{bin}/minizign -G -s #{testpath}/test.key -p #{testpath}/test.pub", "\n", 0)
    assert_path_exists testpath/"test.key"
    assert_path_exists testpath/"test.pub"

    # Create a test file and sign it
    (testpath/"test.txt").write "Out of the mountain of despair, a stone of hope."
    system bin/"minizign", "-S", "-s", "test.key", "-m", "test.txt"
    assert_path_exists testpath/"test.txt.minisig"

    # Verify the signature
    system bin/"minizign", "-V", "-p", "test.pub", "-m", "test.txt"
  end
end
