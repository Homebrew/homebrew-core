class Numbat < Formula
  desc "Statically typed programming language for scientific computations"
  homepage "https://github.com/sharkdp/numbat"
  url "https://github.com/sharkdp/numbat/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "6e5f2d3e912d38c2b55d10e151498d9d7837541502243bdf1330a7b44cd9da24"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/numbat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1d6b1132db298ecd665a68e7ed60529bea0a2b53c4fc2659922e46dd4f77929"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab9742d43434a96323daf9b04d268fff729a3ec5b618e7eded64436eed9c84ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1803003f40e9278bdb76824fc71bedbb43af68611e6cb3be2679f141fcdacfb2"
    sha256 cellar: :any_skip_relocation, sonoma:         "f784ceca1e2a33d4ca56b1fbee26c7ff16db4a2b0ad9bd8fdf3d59c7d9e6012c"
    sha256 cellar: :any_skip_relocation, ventura:        "25d43cc6f2ce4591e10d2c5417fbd00f0fd51002e652d5b85fdb1b50fc990f7a"
    sha256 cellar: :any_skip_relocation, monterey:       "ea69c4b5f009c2d74b754768f07396e3793d74291141beec784ac6fbdd5ba702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7f4b1c4c565413f504cd8371f1a1ae3b40ea090a9f7e70caef1c4c473883fcb"
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
