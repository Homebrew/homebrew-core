class Numbat < Formula
  desc "Statically typed programming language for scientific computations"
  homepage "https://github.com/sharkdp/numbat"
  url "https://github.com/sharkdp/numbat/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "297c4ce1eca68a5f523a537b6d4a7334907f0cd4fbcf2162d1467d6d090c1445"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/numbat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dc7777964e389acd2078a3b132291ff3a980f30e8fffc9f766832fea2786a94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00365ca2186f8f40cca2f2fcd57e6abfb52cc91d60202005fa0cc0d1362d12bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31bd63a0fc512a8418202f77c8c31462200afa408e76175a9093ac059a754d53"
    sha256 cellar: :any_skip_relocation, sonoma:        "69cae3276321fff50f7792763566e58e1578bf2ea0cd337b26eee0d4244788b3"
    sha256 cellar: :any_skip_relocation, ventura:       "264932aabc350940cb7d2100b51319a8f8e62db2afec8b69fa3a2f8fbe3ccc60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4c438182245ac4127ac70679ffd8e83298af1d32f040940db265a26efdf3449"
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
