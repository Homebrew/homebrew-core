class Monocle < Formula
  desc "See through all BGP data with a monocle"
  homepage "https://github.com/bgpkit/monocle"
  url "https://github.com/bgpkit/monocle/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "571f53116c345f1f8279a07e1aaaee3850ceb0fc01ba9c5cef3f393fbefa4a6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90179dc8e760a4a85ad5e03a25f8512295fc528a0f2eed38cc756a8c8a6edc61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62f25e9b9ac204329a2d3452c1e98de2f64e63f6ae3d40e0d1c896d61c679e1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e631476b096bdd088521de3c2ae615874cc20c82a890216a79a82896951e078"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7d4adb1ef908b164dac34ec908485d2af8c2928eb49b6fede7ccedc1b357471"
    sha256 cellar: :any_skip_relocation, ventura:       "b3675f8eb3b4217d5289474d6d420d1fd78598a00d339a3813e826d27d416d5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "429f56dfb8e38b70ddeeded089aa85d2b1cde684c350d369493526d672d7305c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75afdf472f8f6e0978c755ee28f683f52f2025645fe14165ca189b43caacd0f5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/monocle time 1735322400 --simple")
    assert_match "2024-12-27T18:00:00+00:00", output
  end
end
