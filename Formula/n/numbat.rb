class Numbat < Formula
  desc "Statically typed programming language for scientific computations"
  homepage "https://numbat.dev/"
  url "https://github.com/sharkdp/numbat/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "8e4a55813417b5c7671d017475ffa645c0013eb98d44685c43fcf89addf2b1bf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/numbat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "259fff0d229c981162fe97f7695b6e11955694a9a8380b4273039bef41c27a92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ef10cb0cd590e0c77283d9add6a5412a0549b6d20eba0c20f7454bc4c999920"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "315944f822bba99e9d01b2c382d832c42b6821afbc142b1c8cce258d40ae38a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bcb3d27bf6fb9dcc933947f596af80684eb2692724e14e30fd53035fc005bc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c13865a1669a2360320c3671bd453cb057d949c70590e1a21c5eeafbb8e8302d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77faed701700b4ca0b874689b735237dc83aa4f9f3c7e4109456eeac1416441b"
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
