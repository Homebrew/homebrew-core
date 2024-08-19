class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.34.0.tar.gz"
  sha256 "e9f16d28156e1a906f19b267b9fc7c8e47e8f9347c39a7095f0495d4034ce96e"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75d41abf60b38c0ebd1d07a28a1cf49a87f36c2b701d786fded107d44de15133"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f563ea00d296ceb250cc73e0e94568b1140e7303fb2c10d711ca42b0be34a23b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98e98467be3b83f82398526b9749c8dd5a8d04f78fbf3d6cf60b2b5ddecc7ca2"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd9537beb1bcf0a46725dcdcc8a4596e6efb761be5fde510b01465b5a3d7f54a"
    sha256 cellar: :any_skip_relocation, ventura:        "d7e2b8fa772842e146d2f7aa0b7b7bf76dc689211b9c8d23f428237146dd5e4c"
    sha256 cellar: :any_skip_relocation, monterey:       "9915232f481d43d594e11a61414d28e93acbf30aa4119078518d48b7af8bc721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "862a0cd86046e074127bab8be0f4db48e2e5c328847e3bc662848a310fb87459"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"just", "--completions")
    (man1/"just.1").write Utils.safe_popen_read(bin/"just", "--man")
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end
