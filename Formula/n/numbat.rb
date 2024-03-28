class Numbat < Formula
  desc "Statically typed programming language for scientific computations"
  homepage "https://github.com/sharkdp/numbat"
  url "https://github.com/sharkdp/numbat/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "9543f449e758b2db6d1299b4eee88dbeac1ba57a427580c7f45d3ee613b089a0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/numbat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f500774d1d0c974474eef0d30dc80930f8aadb8be9a7038caa88b1d82815b93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16f7bdc14aed3acda44ec859fb90d09fb23813eac5868cb2ec04dc96bea89660"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fa1f06e0133ab891d66e730a7e394045c91a1609f36633e7723204e0929ad65"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fe9a1889ef607f401a407e1bcfb4faedd5c27923219357ddd4458e891745384"
    sha256 cellar: :any_skip_relocation, ventura:        "db7f6996584384f7289ac5b8af50ffafb03ebf368c368e7a48f74460302cbabc"
    sha256 cellar: :any_skip_relocation, monterey:       "48df51ce3c1bd7c6ffd797052a8e9d3566bad581dc17b18128595abc13051dfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a70bdac77a20411cf4e9ab494ff09d2be5594c5db9b03151920e67619bac4ec0"
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
