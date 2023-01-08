class Mask < Formula
  desc "CLI task runner defined by a simple markdown file"
  homepage "https://github.com/jakedeichert/mask/"
  url "https://github.com/jacobdeichert/mask/archive/v0.11.3.tar.gz"
  sha256 "539008c8c138bb38c142d0cc9f84c2b89b43e9eb8f5b349f5d0eb308de49860d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2e0cba1600c3a404b0c65848e5e4ba72a82336df51fdb74c56b9ac7626cc8b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f086816201c09f876e6e3465ad7145862151207f3b60a27681d3fada2d3403e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c99cc0ec74a9a962a0597978bf229c945b39bb1c3d3273674a97cf873540ce7"
    sha256 cellar: :any_skip_relocation, ventura:        "e9f53f5310f57d019e4bbe301f46de8e562433eff4b9c5c058b64c57d0dc21e1"
    sha256 cellar: :any_skip_relocation, monterey:       "b36c0c40193b19d767e99abc4cf4a6c1e81498471134ef36360e43b8882b702e"
    sha256 cellar: :any_skip_relocation, big_sur:        "85fa85c696b792cad05a2143c49b2bcedca1eb1e45bcb51a41822067b264a30e"
    sha256 cellar: :any_skip_relocation, catalina:       "1286dd0adc9263041717b451c0744f367412fc176572267d02a7e3f9248c8ccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbee75fc2c53fa298f600841235a70401a2b8a61a64fd9f9ee5ca70692d29efc"
  end

  depends_on "rust" => :build

  def install
    cd "mask" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"maskfile.md").write <<~EOS
      # Example maskfile

      ## hello (name)

      ```sh
      printf "Hello %s!" "$name"
      ```
    EOS
    assert_equal "Hello Homebrew!", shell_output("#{bin}/mask hello Homebrew")
  end
end
