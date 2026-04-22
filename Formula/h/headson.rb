class Headson < Formula
  desc "Head/tail for structured data"
  homepage "https://docs.rs/headson/latest/headson/"
  url "https://github.com/kantord/headson/archive/refs/tags/headson-v0.16.1.tar.gz"
  sha256 "485c221b28b361c9de2b8223f7985401d37f2c75a2870be6f59af4d83f499db7"
  license "MIT"
  head "https://github.com/kantord/headson.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "854c8655b692c19690c6151da4208ac9250dd88b180e0d2054472e9dd1af4a0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dc83400a096d97f6dab5e950bc8d2858ad36a522921f2f79790725cc83c24f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdd30098b76af6ca0de0d1f54b1cd723b6771efe8c70b1475f24ad9a9af9073f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c8f68eba88fc692027f74798faaccdde4d47968564be5139d4219f661fcdc6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f39390eec0049ead13d96c089221ca52a7f9d2f2dfaab2a10fd45c583ab09327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed7745c0a50256e9ab5f7d047308da959c7922116ba1785086244ebb4183dda1"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hson", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hson --version")

    (testpath/"test.json").write '{"a":1,"b":[2,3]}'
    assert_match '"a":1', shell_output("#{bin}/hson --compact #{testpath}/test.json")
  end
end
