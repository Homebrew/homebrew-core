class Prs < Formula
  desc "Secure, fast & convenient password manager CLI with GPG & git sync"
  homepage "https://timvisee.com/projects/prs"
  url "https://github.com/timvisee/prs/archive/v0.4.1.tar.gz"
  sha256 "f7f8f5d815cf1c4034f1c2aa36ed29b7e3ab2a884791b4b69ffc845d5d111524"
  license "GPL-3.0-only"

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
    assert_equal "prs-cli #{version}\n", shell_output("#{bin}/prs --version")
    assert_equal "", shell_output("#{bin}/prs list --no-interactive --quiet")
  end
end
