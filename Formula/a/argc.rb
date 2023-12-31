class Argc < Formula
  desc "Easily create and use cli based on bash script"
  homepage "https://github.com/sigoden/argc"
  url "https://github.com/sigoden/argc/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "4e1b3b01ef3dd590b1201a84d63b275ab65ce145793a1d15b57cfaa2149d3791"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2094487c0689ac83269b20fcbd5bc238be6dd7b83176aff5f40784e6ffda2dcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b3defcb519435f47e7e5d4a11686b8926ac96faf22397d23e69fc1cac89a3b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d3abc10f619786a137dbc641427874282b50d691e2bc07f5d2a57a80827a14c"
    sha256 cellar: :any_skip_relocation, sonoma:         "01a5f2e220c1f09f459856ef8db4f75fbef65abf5961958ecca2e3738e177930"
    sha256 cellar: :any_skip_relocation, ventura:        "464aa520a5943b24d550894742b220a7e4610ea0fa0ca362b47b01f863fb6535"
    sha256 cellar: :any_skip_relocation, monterey:       "31989421764e1eae6274b8587401f5216ef5076829d9201580cca46edc4d237f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "308e6c47085de40677023bf4d1c3240d0b5463ced5b121fca48fbbc0f7912b38"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"argc", "--argc-completions")
  end

  test do
    system bin/"argc", "--argc-create", "build"
    assert_predicate testpath/"Argcfile.sh", :exist?
    assert_match "build", shell_output("#{bin}/argc build")
  end
end
