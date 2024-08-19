class Numbat < Formula
  desc "Statically typed programming language for scientific computations"
  homepage "https://github.com/sharkdp/numbat"
  url "https://github.com/sharkdp/numbat/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "3c152ec83dd0615cc62d7f92164fabad361d853f3796db22c79c20fa060e26b4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/numbat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0d693da21ed40cc6c93d24a95519fe644d828d26c1e31647607aae67fac5e43"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93e6e770a80b3a47e2ec1ef50b9e874b03285a48cd393e52cb25499a4c6a5e75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78e42f8400a09da9ebfd78d1737be4069633838e0d728dddf85dc0349dad2d92"
    sha256 cellar: :any_skip_relocation, sonoma:         "e70fab1b0ede26601ffcdf48e611c5d0ff059177f5e2af37f01187efd348eee4"
    sha256 cellar: :any_skip_relocation, ventura:        "8458f332db0c4f91ec7b5106dad69fc00d579a7ff39f3b8025d9a8a9df4c7b43"
    sha256 cellar: :any_skip_relocation, monterey:       "9940be472eaa9c79fd6345dd38b67c3837991d2f6ae9945414bd40e3610570fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5485ddbc6ccc66da872b9965702b8e7bb7acad04ff3e780b1d436e1f085353e"
  end

  depends_on "rust" => :build

  def install
    ENV["NUMBAT_SYSTEM_MODULE_PATH"] = "#{pkgshare}/modules"
    system "cargo", "install", *std_cargo_args(path: "numbat-cli")

    pkgshare.install "numbat/modules"
  end

  test do
    (testpath/"test.nbt").write <<~EOS
      print("pi = {pi}")
    EOS

    output = shell_output("#{bin}/numbat test.nbt")

    assert_equal "pi = 3.14159", output.chomp
  end
end
