class Argc < Formula
  desc "Easily create and use cli based on bash script"
  homepage "https://github.com/sigoden/argc"
  url "https://github.com/sigoden/argc/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "83e6bbc7a0f90189db79dd30c6e32040078e1eced8635f860e15e512675e0802"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24f7ae10be03b0011992bd43d39d3ad960ed9e532812ec32450b2e4c6f45debd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f30d6630ada40229f899aaaf2eae2cc09f2724ec4b1254485c4c8826992e815"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77fd39a8307c613dc250cc9b3312aee3127f35f96f887d53cd39068497402105"
    sha256 cellar: :any_skip_relocation, sonoma:         "229040baf236c7f881bd7eac4292602ced86c645433ab9531529c52b2dfddc0e"
    sha256 cellar: :any_skip_relocation, ventura:        "9ac927c13a0f17eb889bd789d79295325080bc117b78374fc8c882da2ab5543f"
    sha256 cellar: :any_skip_relocation, monterey:       "763e907a1ce8a94f7a693d236e41dad9dfc970fd21ba9c0445fbe2a588e9085a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c16497882c9113dcfd110eff9e3dcacbfb3f1eec423ea44eb27023e13e4371ed"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"argc", "--argc-completions")
  end

  test do
    system bin/"argc", "--argc-create", "build"
    assert_predicate testpath/"Argcfile.sh", :exist?
    assert_match "build", shell_output("#{bin}/argc build")
  end
end
