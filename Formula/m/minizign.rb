class Minizign < Formula
  desc "Minisign reimplemented in Zig"
  homepage "https://github.com/jedisct1/zig-minisign"
  url "https://github.com/jedisct1/zig-minisign/archive/refs/tags/0.1.13.tar.gz"
  sha256 "018f768d5614a1fccedf806b62f5614a179507f4431e8df0574d2dd38e5d31e6"
  license "ISC"
  head "https://github.com/jedisct1/zig-minisign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c79df922a2d3c6c37cf7295eff50f6bea3e56ded6d2daabf6854943eb825629"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db6b7e50805d2ca5eabed6299b6b77bcace0b030e2f81e6f78ed3965298165b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "047dc14e3448fce68827a85711e4534028bfd9e1754773892c50a91ae2627e22"
    sha256 cellar: :any_skip_relocation, sonoma:        "573882e509717d889f73f17df7bc0bfa688a7e1a24cd8e10393b4ecf55d1cc66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff9db5247b3e9fb120a9ee1841b7660f3bf489be1a0f157ab9ca1bb57b71edfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2f745cbd517ad2ce762fe8474ec3246b4ea1f67c5914d0f93dd4b6d4d0d8e02"
  end

  depends_on "zig" => :build

  def install
    system "zig", "build", *std_zig_args
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
