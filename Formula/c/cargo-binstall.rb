class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "c64579b95ed3c2e47182cd32e96741dcb451ede1190a1cbba2f27c9dd482faf8"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3461e98f8bdd677156ff23b8d0f02da894fce4272682ad6d299927d2072164a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "089744e30577f8d3415d47a2ba299f9527aead74d8d85ad27e7422316c386d2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e37980e86a506c8068aaa2f05ce267a2c2e21dd70db896688958f28868a92530"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea5e41717f6e46a10914fbc98b0d47d0887b2e684bcc253572877b5283ad13a1"
    sha256 cellar: :any_skip_relocation, ventura:        "135ed83d6e6309c27e478a1e5ade1b0a65bff8146812768b0d113569d9f4eeab"
    sha256 cellar: :any_skip_relocation, monterey:       "563dd8c5fc6414cc1f7c3a342c12b06a5860b63f784feffbf2985c4fdfa93d63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a34752f2fdb1ec723a2bcc067575fa57387e82bf76a94b37be00eec1e97ba08"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end
