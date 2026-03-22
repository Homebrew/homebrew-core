class Numbat < Formula
  desc "Statically typed programming language for scientific computations"
  homepage "https://numbat.dev/"
  url "https://github.com/sharkdp/numbat/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "578c0ff6cb80098baca84042a104644758907002e4fc7ba839a1266be7f4af28"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/numbat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42efb059afe4151561edd4ca071bdebec12e1ad54ebff646cc9b3019fbcbfe57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3cedcaca702f1509f2806d177feb601003d8d7455f4b2a83cfe3a83457450ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3889a908520723c35e3c597318aedcaf46d1ee10d7411b29fc77d5937170a1ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "436601d4daa6f8d8bac24dda906ef04a621cfaaca1eced925b410d340988c976"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04be8a287921f3add7d40f7ab38bc97f22b0966dce8d6915f2e5934222ac36f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cf98475c54b7074d9b5b964e1640d3477bf4db053768680be189901ba78ee94"
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
