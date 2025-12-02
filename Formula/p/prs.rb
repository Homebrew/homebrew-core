class Prs < Formula
  desc "Secure, fast & convenient password manager CLI with GPG & git sync"
  homepage "https://timvisee.com/projects/prs"
  url "https://github.com/timvisee/prs/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "833e47894b64e9da25183782fd10b16c6879d201cf5f60e02ce3d4c654309f53"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6b6ba3893c637d7d43c3cd63427f125b0e0033a04247284b8fa81e6daf2c72c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eccd7f0e9e1519265b50002aa29def833a870cb826cf3e71ee1231b493181acd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3514b10156042e9b99cf4dfe627ab9a968178ebb21b85e25e8a7ab264cd35d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f612132dc672132ed25235e3678b17658f5acad5d0efb226174374c0787fe8d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2a819c27ce1f9742733d7e6f5e79dd6ee9ee75f7caf7a66d03052bf6b7b062d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7481a21f903a29e8dc9dcc33b321aa5253a6089b0ee088315d3513a73371d2ad"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "libxcb"
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"prs", "internal", "completions")
  end

  test do
    ENV["PASSWORD_STORE_DIR"] = testpath/".store"
    expected = <<~EOS
      Now generate and add a new recipient key for yourself:
          prs recipients generate

    EOS

    assert_equal expected, shell_output("#{bin}/prs init --no-interactive 2>&1")
    assert_equal "prs #{version}\n", shell_output("#{bin}/prs --version")
    assert_empty shell_output("#{bin}/prs list --no-interactive --quiet")
  end
end
