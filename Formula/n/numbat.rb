class Numbat < Formula
  desc "Statically typed programming language for scientific computations"
  homepage "https://numbat.dev/"
  url "https://github.com/sharkdp/numbat/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "33f3744a31f62f7ebd985c6b3ec3c6a6d6f897527e8db5bc2de48dd299a63cdd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/numbat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d92b9b3aa2eaafc95ace71da1e41d34e1f6edb5f7f7490d1b6f7506446e1406"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "487fd2bfbd8ac5b590386c8686b32335c475a4aa49fe7e5a58e5a4e6e3dd44dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d23f0227df669a913c50a2a48b6be6ee98ca4375bf554cd443547e8ffa76b237"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0415e2b39effbd9843b5454705d157f76a842fa8c6c4399a78af8edf45e56bbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f45d7ee45e0db01d8ff53ff4d6eb96157d4d5a1cc707d5f7b56de73659fe2cb6"
    sha256 cellar: :any_skip_relocation, ventura:       "ac553d4a9495b73b7a6bb60d24e997c77efc41c61d25f338cff93b4ab5f747f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "510a56a4eac2d79df0ff557d3c38695f9a8434a88ee2f4ebb587647a1e686cf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45335ba3caf2597ba12c9ee5f1a942f488c015bcd6b4b204ba0151ec056e5d07"
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
