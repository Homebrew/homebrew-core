class Envio < Formula
  desc "Modern And Secure CLI Tool For Managing Environment Variables"
  homepage "https://github.com/humblepenguinn/envio"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/humblepenguinn/envio.git", branch: "main"

  stable do
    url "https://github.com/humblepenguinn/envio/archive/refs/tags/v0.7.0.tar.gz"
    sha256 "729a02ac8a5e129fa5129de6ee62f7e2c408502dafc25924d65d02558caa5a08"

    # Fix missing version
    # TODO: Remove in the next release
    patch do
      url "https://github.com/humblepenguinn/envio/commit/37976a3d0327435d631b6ac6eff1ad114472f148.patch?full_index=1"
      sha256 "da23f201ac3b20d8c6cff09d95496fb6c4e88ca9c737351804b6a84bf3a9293f"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9e461ece805b428cc117de9bab60d6b3480e394a1ab4773ce7cbbaf84dcd12fd"
    sha256 cellar: :any,                 arm64_sequoia: "d9984aa667eea7aedfab98a2ba0e320e10209e0d2bf8477d52dc60350ca39081"
    sha256 cellar: :any,                 arm64_sonoma:  "e9dbfa5d209c868943a43639c22f9bc9089aeed36e9e5f71daa927a683ca3b02"
    sha256 cellar: :any,                 sonoma:        "471ab5750a38dffdbe044e4cb12ef3dd5f8d33d453e922c575f43fcd03d37319"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d327cb2ad2bb9a981ba480e620eacbd098a64fb6717c0c38aeca0b0445d0b37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11dd45e470b900a216a0bba3da45f775943690ee1e1241d5319d50a4e166425f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "gpgme"
  depends_on "libgpg-error"

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man/envio.1"

    generate_completions_from_executable(bin/"envio", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    # Setup envio config path
    mkdir testpath/".envio"
    mkdir testpath/".envio/profiles"
    touch testpath/".envio/setenv.sh"

    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS

    system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"
    gpg = Formula["gnupg"].opt_bin/"gpg"
    fingerprint_output = shell_output("#{gpg} --with-colons --list-secret-keys --fingerprint")
    fingerprint_line = fingerprint_output.lines.find { |line| line.start_with?("fpr:") }.to_s
    fingerprint = fingerprint_line.split(":").fetch(9, "").strip
    assert_match(/\A\h{40}\z/, fingerprint)

    begin
      with_env(ENVIO_KEY: fingerprint) do
        output = shell_output("#{bin}/envio create brewtest --cipher-kind gpg")
        assert_match "Profile created", output
      end
      assert_path_exists testpath/".envio/profiles/brewtest.envio"

      output = shell_output("#{bin}/envio list")
      assert_match "brewtest", output

      assert_match version.to_s, shell_output("#{bin}/envio version")
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end
