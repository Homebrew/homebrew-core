class Fuc < Formula
  desc "Modern, performance focused unix commands"
  homepage "https://github.com/supercilex/fuc"
  url "https://github.com/supercilex/fuc/archive/refs/tags/1.1.9.tar.gz"
  sha256 "5301e4634b8de57d1afb4111b0623f2c3967f9a160a043914f0fa400a77dfbc3"
  license "Apache-2.0"
  head "https://github.com/supercilex/fuc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69c66a77137034b3e41cfc88710a14b8c220c9737e071c02ab0cbf9460b35458"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d50882e7c4faf66788f52efdc8c1c5f25872f8885023867afb866802e95b31bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62d7ecce53528411b3cff5bb2b9e5ad9afbcf029608fafa3d1ef68a0768293a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdd63f4fd3c2762a74fd263147480c9e19596f0801aed05f7bad143138eadff4"
    sha256 cellar: :any_skip_relocation, ventura:        "ff351a9ecfb0e010291431111c3fb8b3e647b96497dd8f6200819fd09c4ba3e6"
    sha256 cellar: :any_skip_relocation, monterey:       "5fff21627f0b9ff9300ca72964ded717081d3972b7710e9777de62c2e515bb95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00f0256dc922114c944712b4122b7ffbf381280649e87ec3199e07a5d24e3e94"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cpz")
    system "cargo", "install", *std_cargo_args(path: "rmz")
  end

  test do
    system bin/"cpz", test_fixtures("test.png"), testpath/"test.png"
    system bin/"rmz", testpath/"test.png"

    assert_match "cpz #{version}", shell_output("#{bin}/cpz --version")
    assert_match "rmz #{version}", shell_output("#{bin}/rmz --version")
  end
end
