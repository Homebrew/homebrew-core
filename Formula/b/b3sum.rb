class B3sum < Formula
  desc "Command-line implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.8.5.tar.gz"
  sha256 "220bd81286e2a0585beac66d41ac3f4c2c33ae8a4e339fc88cf22d5e00514fe9"
  license any_of: [
    "CC0-1.0",
    "Apache-2.0",
    "Apache-2.0" => { with: "LLVM-exception" },
  ]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "747da6f8ba0c8436f3ac3e66aaf5f58730889f6bc6d238c423b0d4969d52b9c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d60d374e9261723c3af62cd48d0b115ba044afaed3ff09cde4f2f4693ffca02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5d460280c439be2c378f4e3e36fa110d32a29576bd167e7fccf6086a42b8c41"
    sha256 cellar: :any_skip_relocation, sonoma:        "028850c4a12468176ad60a40f9a141b3450e67ea86e51bfbf4adf4f6cc827d01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "766e5afe0e8ab29d9e4e3f04a7a33edd0536172f99d0b598886d707e9e29dd9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47373f5ebe532f264a177f470452a62ce8c037b6b0f1f3d85bc24b0024608731"
  end

  depends_on "rust" => :build

  def install
    cd "b3sum" do
      system "cargo", "install", *std_cargo_args
      buildpath.install "README.md"
    end
  end

  test do
    output = pipe_output(bin/"b3sum", "content\n", 0)
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  -", output.strip
  end
end
