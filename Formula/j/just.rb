class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://just.systems"
  url "https://github.com/casey/just/archive/refs/tags/1.54.0.tar.gz"
  sha256 "53d288296054876d4d9fb76b0f947c3f2a805969bfa19ec79108da44e70cd93e"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c729be9075687ade5b8c98b470121fa4dd980c137933ed24497f0720dc984a3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a218eb7785a1b2976bd57434f67198dfdc5d7e0c42735e33f46061b943c78c10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d220cfd1157164d00790414e18de9ab122a3de18b121dcad2f9af2d0057b13c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b3d07c4d1cf2669b23372d2b58e37adb12ea1b6519005b7d48a65e4a513f138"
    sha256 cellar: :any,                 arm64_linux:   "2357c095cccf60d000c6cbd677194d07f09493e7063d7f8e6b0bd2adf2ac7223"
    sha256 cellar: :any,                 x86_64_linux:  "2770cc20ad1b79d321522d1afac13f36d61a8bb9199d03ed444292e4f1548c79"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"just", "--completions")
    (man1/"just.1").write Utils.safe_popen_read(bin/"just", "--man")
  end

  test do
    (testpath/"justfile").write <<~MAKE
      default:
        touch it-worked
    MAKE
    system bin/"just"
    assert_path_exists testpath/"it-worked"

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end
