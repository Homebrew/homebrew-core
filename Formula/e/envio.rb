class Envio < Formula
  desc "Modern And Secure CLI Tool For Managing Environment Variables"
  homepage "https://github.com/envio-cli/envio"
  url "https://github.com/envio-cli/envio/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "729a02ac8a5e129fa5129de6ee62f7e2c408502dafc25924d65d02558caa5a08"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/envio-cli/envio.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b18308e8847f096e91c31c563e0e4ca6b0a87a260ac6f3ef680ea8ab477dd9dc"
    sha256 cellar: :any,                 arm64_sequoia: "a3e048b909779bf06ff1fafb0da2f95b9463173957346bcf5e7023ff041f5a37"
    sha256 cellar: :any,                 arm64_sonoma:  "3cefe805698e54c6b61187c0d038ce4c4c78d3819055109d93177f82691b215c"
    sha256 cellar: :any,                 sonoma:        "19125731457442ee02d534d4cabb9f7a31cafcd7aa75fbebd87af772396b052a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "669a6d3805a14be62a553178f9cf31571a7db0717bbd90e5d5668046ff32e35b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ff6c6cebba244c79d927a9203ff657318d0af4290f95941888deb1dec58fc34"
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
