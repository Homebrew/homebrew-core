class Prs < Formula
  desc "Secure, fast & convenient password manager CLI with GPG & git sync"
  homepage "https://timvisee.com/projects/prs"
  url "https://github.com/timvisee/prs/archive/v0.5.0.tar.gz"
  sha256 "c09b563181bc58b49db8e4f015749785798bd55b35a1f1924b3e432fa5f387f2"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "961985744643a37b043e0b97f5150faf69e27f3ce98990b16129a8e13a71a7fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66e43ef6f5409c9c2e1ffcf7be721d3186b851e14e9db754e925d7097e77349c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac727e06c559e5c64c0f6b6dfb99eddcba297d1ffb45ae0b24ca2159c4e52270"
    sha256 cellar: :any_skip_relocation, ventura:        "b7254d21e5224ea4b53d48d4c1611e755dbadf661a80865bb504d944bfde2378"
    sha256 cellar: :any_skip_relocation, monterey:       "1cdd752d854769e2f6c6936a4897334474a1fc366023ad7b1c6ac4c7a3fbc822"
    sha256 cellar: :any_skip_relocation, big_sur:        "98da3f34c0555a262a36c4dfc6b424e343804ce3f47d92294298a2aeb4d9f3ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21a2c5f858ca44a69618624efe280a8808a382d4b226a5626f6a01bb14c79a98"
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
