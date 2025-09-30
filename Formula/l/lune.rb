class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://github.com/lune-org/lune/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "f4b143641741bdb7977696ad795d4cc890457020437622d417f240dfd2901a6f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0165dbc9a43c0213c31e9b1c576ef6385615174d2877ffbdc36afe332114557a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3eb93f4681d44851ab7e14d5e7f16f3165932f87db86e57baaea64b4fda72eaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c51fe5f509953866995fa6808512657a128f6442a039cd0031515f25d381b6de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "faf09f47239ccbca7478ecb4c381e64e3ecf3f3456e87e1cc1c723917ba469df"
    sha256 cellar: :any_skip_relocation, sonoma:        "304a8590f6b0a6ca1b281c062845417a3052e46ad09926295fec9e78a5db059a"
    sha256 cellar: :any_skip_relocation, ventura:       "3c8a2010940f5f4b5690cea18d6e03d043d848467ac724d0e960cf27c70f41a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "906a017ae57443f26d5d80ef1e4a94bc8173275473a5b5b75ad54c29442fdf71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4b51ba68ef6035cacb268ab2d074bd2f574d51a43207330719697f21d2c4469"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args(path: "crates/lune")
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune run test.lua").chomp
  end
end
