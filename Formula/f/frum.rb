class Frum < Formula
  desc "Fast and modern Ruby version manager written in Rust"
  homepage "https://github.com/TaKO8Ki/frum/"
  url "https://github.com/TaKO8Ki/frum/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "0a67d12976b50f39111c92fa0d0e6bf0ae6612a0325c31724ea3a6b831882b5d"
  license "MIT"
  head "https://github.com/TaKO8Ki/frum.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d4203a88fd187af4d84738999e3317c6d57ec0cde8cbd16f39704810d937727"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ce32dc8ccdd4bfe73e4720b6dfb3c7e919d2fcc363afb034718b0dc1319a025"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cae08b662a22d00190aeec2c62253b249ee576762d6b05f88c24f492adff767"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb3d9f9b3216b960d432c39f5fa753e4eb5f9743cdb701fa0c31782b97b306dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff8846cf4f783572ea245f1a4754632dd00b15624e54eab740fb4d9479f185c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38b0f40fe2f458c5f9a441b7b401a5a13f5998ea11ebb1cc42249d662a77bea1"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"frum", "completions", "--shell")
  end

  test do
    available_versions = shell_output("#{bin}/frum install -l").split("\n")
    assert_includes available_versions, "2.6.5"
    assert_includes available_versions, "2.7.0"

    frum_dir = (testpath/".frum")
    mkdir_p frum_dir/"versions/2.6.5"
    mkdir_p frum_dir/"versions/2.4.0"
    versions = shell_output("eval \"$(#{bin}/frum init)\" && frum versions").split("\n")
    assert_equal 2, versions.length
    assert_includes versions, "  2.4.0"
    assert_includes versions, "  2.6.5"
  end
end
