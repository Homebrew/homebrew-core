class Envio < Formula
  desc "Modern And Secure CLI Tool For Managing Environment Variables"
  homepage "https://github.com/humblepenguinn/envio"
  url "https://github.com/humblepenguinn/envio/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "694e68d3434c951f17d778315eb8ed3de9d4934ae834d7368bd700751a385620"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/humblepenguinn/envio.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df7e57535ad3830ff003f53e1124ebe879a74867bf5688d89432d52a9173250c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2e43b713ed2cf6335250f0eb8a9a024a8410d7a98e9c1324c9cb07761b41824"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4b1c50ae8611c34eabc1627e7b4d786811d6e07e1f76981a7e1ea0e0812c899"
    sha256 cellar: :any_skip_relocation, sonoma:        "be708a55a04644168c64fa5f7a73ba3daa5dd728a03fa5ee8a5e4012eec3f173"
    sha256 cellar: :any,                 arm64_linux:   "54de753f51ef02b66f1bc23cadc8f069150024f4edd26c33bba010353f712d85"
    sha256 cellar: :any,                 x86_64_linux:  "4bdd1a9db951f83f81124c3681c2e291cf5cf37653b344452b9ce5499da88427"
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

    (testpath/"batch.gpg").write <<~GPG
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    GPG

    system formula_opt_bin("gnupg")/"gpg", "--batch", "--gen-key", "batch.gpg"
    gpg = formula_opt_bin("gnupg")/"gpg"
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
      system formula_opt_bin("gnupg")/"gpgconf", "--kill", "gpg-agent"
    end
  end
end
