class Prs < Formula
  desc "Secure, fast & convenient password manager CLI with GPG & git sync"
  homepage "https://timvisee.com/projects/prs"
  url "https://github.com/timvisee/prs/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "9a4cc8371ec166c0a62da12cdb2c5e053fe399c49b026dea9c67258546630abe"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41f5ddbded8685190e165a3609a1d1e1cdcd03d2cf628610c731ff2921d8b3ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c179ab6efea0b20ea6728f741ccf68566fcd3116ac0c1ad37e34664962b5829a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03e32f7a7be5705cd65bafd8b91d464be6b8aa8cbbe743ea0a2084e4ec106f51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0d06a166a4be290c1b2246d441e21f6d27a4f8838678700f51aa61637abc471"
    sha256 cellar: :any_skip_relocation, sonoma:         "19acbc995def350dbf7d6508011da04f407a1a2a806de4871a5e5f141cb035db"
    sha256 cellar: :any_skip_relocation, ventura:        "ae05b51b6c3f02790bdf22f00717bf9ae155e037c15da735ce1689710b4a5a08"
    sha256 cellar: :any_skip_relocation, monterey:       "fbc0c4071ec4a681c1c129ebf83af025dfc535bca1775e7ee3987f15c7511e17"
    sha256 cellar: :any_skip_relocation, big_sur:        "9dbedc7e970b7354bd9951175941c06e9bce761bdef08b8dda507e3da290db98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "003944e33f04aad5fe54bcf3f5ba832c2cb12099ff0b12f9606e311d8dcd69c9"
  end

  depends_on "rust" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "pkg-config" => :build
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
    assert_equal "", shell_output("#{bin}/prs list --no-interactive --quiet")
  end
end
