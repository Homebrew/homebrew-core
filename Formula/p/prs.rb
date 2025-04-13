class Prs < Formula
  desc "Secure, fast & convenient password manager CLI with GPG & git sync"
  homepage "https://timvisee.com/projects/prs"
  url "https://github.com/timvisee/prs/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "9d1635ca4c9e916d9c59e05e792f0bdcf249488d63b615d30660a5c8371ab3b0"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc1d09e088e2321644ccede82abc199cf7ce4531d5a251818bc7655a05b08690"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fdd9e3be383c66234f0fbc89fa824712756fee672bba0d6a7b0aecb4b58747f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b651bcae0d249232460b03fab22c239a319f977169996197098fb082509685f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b4d56aa801a5b49c63aa220dd73642847cc2469c25776a1e11e91113d8be776"
    sha256 cellar: :any_skip_relocation, ventura:       "ffd6725497618bb411cb83db32edefe40e6a70260b1cde0801fbb4b45ec4f428"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b65df02f12c0b730c212b28b88e3c00f0801981e7069bbccb4ce21befee38181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7d2a746d0612f19d99b13216ecbb08dc5fd06fe1e7ff6a9d1690becdba707ec"
  end

  depends_on "rust" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "pkgconf" => :build
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
