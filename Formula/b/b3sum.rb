class B3sum < Formula
  desc "Command-line implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.5.3.tar.gz"
  sha256 "ec9114480857334858e73b727199c573bfdbed6138a83be573f076d37e671fc1"
  license any_of: ["CC0-1.0", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aaab178c04381256296de0d8095cc95ff92205da9bdfd5fa4a6f28e43b58ae43"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f657ebfafd091f839975ee5ebbb639e7986326fe8f33c70ac38bc0f4bf5c0493"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0cd66e2e6ae062f4dba4842501d40492f651a98b19b0c3798129bbcc8bd4c1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "d11f1a398541feb0ae99fae46aa8563f7a7ed7773d2bea4120a57c27d2382d81"
    sha256 cellar: :any_skip_relocation, ventura:        "32a03170ffa69aac9f7799b93fde1bd8d47a23a81e08d07c3892766c9ed2ea53"
    sha256 cellar: :any_skip_relocation, monterey:       "293d22e08d7bdfd761f8707d6568d34bb7bec9d75f99e2239481e430ded17229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06707b9dc5b8cd6ea94cd517090de80fa23a957524279984d44140ff5be3a626"
  end

  depends_on "rust" => :build

  def install
    cd "b3sum" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.txt").write <<~EOS
      content
    EOS

    output = shell_output("#{bin}/b3sum test.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  test.txt", output.strip
  end
end
