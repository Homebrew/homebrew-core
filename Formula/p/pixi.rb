class Pixi < Formula
  desc "Package management made easy"
  homepage "https://github.com/prefix-dev/pixi"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "50a266976c4d6c3ea82be68ea112c2abff522241e4493285cef9b79063c4fc22"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/pixi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d949c996ca66164148853845196551580d31b19938635b850b778ff37b5d1f12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31a4c3daaf86edd1d258ce88959d1ff7a04eb9f7a01ae9b8a0b6afcb77276c99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad0e214d833786e1d0b5293905553995dfa9b8a26cbbec0fe1313032c2bbc21a"
    sha256 cellar: :any_skip_relocation, ventura:        "49ed054b54ae66554d1cfd715ec6777302951303a08324de7fc1f7e2910d9d39"
    sha256 cellar: :any_skip_relocation, monterey:       "ae1c0703d7ca09d780f4d2c136d1713997a3b36cfcf0fc087607ac0951e8e527"
    sha256 cellar: :any_skip_relocation, big_sur:        "5586002d546c66ad12a9b3d29643673b8e90a7d600d05518010274a089e3378f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57b28bf9349516128e7704596247461686b0f7c838315c6b1af4dc8ccf719c9b"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip
    system "#{bin}/pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end
