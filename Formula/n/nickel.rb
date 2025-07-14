class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://nickel-lang.org/"
  url "https://github.com/tweag/nickel/archive/refs/tags/1.12.2.tar.gz"
  sha256 "1161b901c238d78dfb2529fee878f37d69c4187ba10d5bd0e2723836d19f7c15"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6666f5ff4b381a85dcf538ba056203167e2c669e4173e41cef8eab1f13123057"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8903536a680884d3150006ee694ee13a3508defd8a68fec68380894f79c8d894"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ca9716e70bdf8575fb7fabd5fe18775111fa748b1a598d2aec968eb6ea2969b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d4103a75a33975a5c2c1f452cbaef3d28e130d2d0ce2fac2bcb5d1bccd51ad6"
    sha256 cellar: :any_skip_relocation, ventura:       "9342e535eaec5f3c73a9297656c42d963cf72a619e9fe31984cacc96770ade8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d6d876bf120d9a6774351ecc78a964530e229a190625e4a515baf05427de7dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a103224c932f06319875d59e95b88c312fd3160a67c6f9b80ff5b5ee852c1a7"
  end

  depends_on "rust" => :build

  def install
    ENV["NICKEL_NIX_BUILD_REV"] = tap.user.to_s

    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"nickel", "gen-completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nickel --version")

    (testpath/"program.ncl").write <<~NICKEL
      let s = "world" in "Hello, " ++ s
    NICKEL

    output = shell_output("#{bin}/nickel eval program.ncl")
    assert_match "Hello, world", output
  end
end
