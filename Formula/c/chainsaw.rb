class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https://github.com/WithSecureLabs/chainsaw"
  url "https://github.com/WithSecureLabs/chainsaw/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "babe48ef1d6c7129299b1a3696aec12fbd4938a7e2b77006ec0c9f76e6e8dc4e"
  license "GPL-3.0-only"
  head "https://github.com/WithSecureLabs/chainsaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1589f04a8868129087cb8df65a5e6055cb8c1951fd68dc3e06c20f7dba249205"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b995a19240d8ed9aceb7002cadb47b20fe87036c5faf95548c68c545cd2d94da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "605b064889a35ef4f5081985cab840a1f291d7264acf039b23fa57233a5ada30"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c2c667caca65d9451dd9f390853d8d2df9080916369b6c2275c8f97c72af02b"
    sha256 cellar: :any_skip_relocation, ventura:        "f812ade11f9406c58a5f5c22f93d08f645e811e9a528cc447b423548c8ca412f"
    sha256 cellar: :any_skip_relocation, monterey:       "8c350c6f326c84ec8c2c1570052906324f3690fc69771bd23b59510c4dc7c9b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bcdce98ea84aabf7c0bb2638ff534373049c63e4516ab55ff1816f09528a60b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    mkdir "chainsaw" do
      output = shell_output("#{bin}/chainsaw lint --kind chainsaw . 2>&1")
      assert_match "Validated 0 detection rules out of 0", output

      output = shell_output("#{bin}/chainsaw dump --json . 2>&1")
      assert_match "Dumping the contents of forensic artefact", output
    end

    assert_match version.to_s, shell_output("#{bin}/chainsaw --version")
  end
end
