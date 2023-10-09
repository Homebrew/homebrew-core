class Pixi < Formula
  desc "Package management made easy"
  homepage "https://github.com/prefix-dev/pixi"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "3b0d54b90d7fe45b5cd42c7f340403585efa210547ffd9bc67381a35e14d1b4f"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/pixi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3997688af59bcaeb237e1fc1b58136c99309cf845ab06011b0df1ec04471c84b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a90c33638b17028bc1ce171d43b121b762ce9e103c49d7fef5234fbb70bdd6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "941e08df10538064cd60880d881d6055ca0a7e355b187e86b6b1642cfa1b68ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "0bbaab62f485bef82bed8c67688799ee585689d60bb82ad26451afb08a071a1e"
    sha256 cellar: :any_skip_relocation, ventura:        "01f5a77a8c788f37eba1dc3150fbd89a025fcfcaa10efc41548577c76db60754"
    sha256 cellar: :any_skip_relocation, monterey:       "71ac1f78606fa83610d253b7f39f9915f917a3d6c39b94eec137d1cdf60c89a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc59d373fbda4e8ac510ed4b6dae72d0bf0a55bc7e6cf013863ead32ea13c4b1"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

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
