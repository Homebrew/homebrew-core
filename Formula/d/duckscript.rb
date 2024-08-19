class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/refs/tags/0.9.3.tar.gz"
  sha256 "c73827af830b4c54903143839ea29651a991574ce6aded613fc077d095ac0c14"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f99441500bd4b4f1d679761fad30c40af7dc7507cded285b3051ed762fbb22c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41c6eaea6bb193ea64b815068454f6079dd810359a20005d5a5e3934ce5872de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "929fd5c227aa1391145ad124780188dc9630bdc6f6eac43b7a621f1bbc34906e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e6f6deec2c5bbf8cee875daeeeb8c72173fb98f3366af2d2d5ee4953f764de5"
    sha256 cellar: :any_skip_relocation, ventura:        "147d01070177af9d864e7685db3a484b807f266790c3232ff872c6c70b38ea58"
    sha256 cellar: :any_skip_relocation, monterey:       "9c9b387692bc68d3f0373c57dade64a24c617ec2d4b6f08ce1d49d81008aefff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d3f766580f60b4fadffb56a49c0186b6417a682a74bc0e433b78fd6c464d7dc"
  end

  depends_on "rust" => :build
  uses_from_macos "bzip2"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  conflicts_with "duck", because: "both install `duck` binaries"

  def install
    system "cargo", "install", "--features", "tls-native", *std_cargo_args(path: "duckscript_cli")
  end

  test do
    (testpath/"hello.ds").write <<~EOS
      out = set "Hello World"
      echo The out variable holds the value: ${out}
    EOS
    output = shell_output("#{bin}/duck hello.ds")
    assert_match "The out variable holds the value: Hello World", output
  end
end
