class B3sum < Formula
  desc "Command-line implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.8.3.tar.gz"
  sha256 "5a11e3f834719b6c1cae7aced1e848a37013f6f10f97272e7849aa0da769f295"
  license any_of: [
    "CC0-1.0",
    "Apache-2.0",
    "Apache-2.0" => { with: "LLVM-exception" },
  ]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6aaf982754d33580087973ca57abe9cac3e80a9555177128acfb0d172deabbb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f33d4bcdc088033950592a36f76b8f05f9715d24443e6f77ec4f727883859680"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f4512945637551c43ecedc21c8155d7db4fd366ace20cba409d049a9d00fe39"
    sha256 cellar: :any_skip_relocation, sonoma:        "b268f3ce958127c16a7ea5d433c4ca3ee91d1363ea18f575d1f185610cf2b8e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45792accea89ca0d2d227df9261cf7d894cc7aab297abf8edcb258e085c70aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "826be694ff9a93cb3dea1f7dee19533475c00e97a7c058878ae0dd3dcfc44df1"
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
