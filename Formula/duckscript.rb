class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.12.tar.gz"
  sha256 "04b8cc724700e89ea9f8643a5566889de76068e7d60fd28f5b28bd308135234d"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e332bd094b4f3266119393508087848394d9f6fb90865de64add356b040c5fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f465081caaca632be159a65350168e12b086183f03b6dbf2fe689d57689d2164"
    sha256 cellar: :any_skip_relocation, monterey:       "47feceed180087fdb7f4f327bf0215791e95de3f750bb2040ebfe6080c34ea2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7216b1892a214a334f5d74edbe3ab4de2b36cdcfccbd32df00e756408c57f828"
    sha256 cellar: :any_skip_relocation, catalina:       "bae56a695e2777043df94ece65ce6c376da95f0cf5971d55b6e64a6c5a2de008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "044b8eec2b5d4cfe94c0e5de3b35579d9c3e37013ccced5cba357391245068de"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
  end

  def install
    cd "duckscript_cli" do
      system "cargo", "install", *std_cargo_args
    end
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
