class Hgrep < Formula
  desc "Grep with human-friendly search results"
  homepage "https://github.com/rhysd/hgrep"
  url "https://github.com/rhysd/hgrep/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "a8c554bab136be4083429e97a41d70b8cabcdf113ac3a2ce6c801b5c8710d1d2"
  license "MIT"
  head "https://github.com/rhysd/hgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdc73fc805440e15b720a25825a116fe80353b8b7169932f6fdd0b2d15259184"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d49c3f35512cd5f2c75ee590bd320c5a4d24785181319e00b63e08be3af99280"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9df4b9b5224a7972f504d5c34ba609ee631abb70a2ae1749753a4dd50216b3a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a874051334cff79a342cfae5c56daebfd5d0f4c78e8d32ab0290e456b980eebb"
    sha256 cellar: :any_skip_relocation, ventura:       "1f2b68a3c41557c21771eb8d59946310a58f2df48aa505c0e9e8f2b0e9e4f07e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "016725006c81ba59a24815bdc72a82bea7b912ad346d0770658bb8bc3399188e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "471b142b6b7286f5f3a0240fe951dc555cd29be2a5233a95af1fd08983673c18"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hgrep", "--generate-completion-script")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hgrep --version")
    (testpath/"test").write("Hello, world!")
    system bin/"hgrep", "Hello"
  end
end
