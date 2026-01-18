class Numbat < Formula
  desc "Statically typed programming language for scientific computations"
  homepage "https://numbat.dev/"
  url "https://github.com/sharkdp/numbat/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "29ebaf622dfb0c1ed142572f4a0a9a5a546b9b2d51149260ff64078ed4c233cb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/numbat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a24e0446d31527147843c8519c2a7aaf08f4b5aa3436eb83a5a49366669ca383"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e88cba40fb772b90c266d5881e561c262891f2fac8bbe7069bdd6f03179a7ed9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80bf230294811f6a84a670c639514d4606111ee8fbd5a1e54c8da80ed776b7c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b48ee3f8c49eb9d651ad7a1edbd80a9868c1a12a7e2b0828d4f19c86be079d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "975409f76fb5c1c48697b7c591322f94391d4468c822776dee537ac8f2b55b7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "155f80625888847e6936e44ffaa8270bee0f3c2117fc4c3b3b03c829dc432853"
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
