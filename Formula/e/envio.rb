class Envio < Formula
  desc "Modern And Secure CLI Tool For Managing Environment Variables"
  homepage "https://envio-cli.github.io/home"
  url "https://github.com/envio-cli/envio/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "24cd7c485226be7f7921a95ae4edaf3cb510c90a339c51e51423c3eb4deee6dc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/envio-cli/envio.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f0d968440fe2fcddd6c39d2541817b3cd51267e520d06ecd2cb1e80f03ffd4a5"
    sha256 cellar: :any,                 arm64_sonoma:  "1a0588163752bdb12f4b0d8e91646345b8c798006cf240328703d1e0a508ebce"
    sha256 cellar: :any,                 arm64_ventura: "4f5305056a8165baf2b45d71b2a94f9800792923949c44a30c030d8b0072ef49"
    sha256 cellar: :any,                 sonoma:        "6812bb1eca12a3c74c542d967d2930bbeb2a0a77ab4b0d3f04eba9df5196063c"
    sha256 cellar: :any,                 ventura:       "777f696105129c6c3c49944c45854d9cc3f5f63cd2e5913d6692e2337c684f88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c7c6e0a4e87038b3088fc5fca823ca57878ab6bb156c7367c4f046debbcb426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61427474955a6e35804f605178403e2ac41bda326841faf024ba873b88824c0d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "gpgme"
  depends_on "libgpg-error"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Setup envio config path
    mkdir testpath/".envio"
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

    begin
      output = shell_output("#{bin}/envio create brewtest -g #{testpath}/.gnupg/trustdb.gpg", 1)
      assert_match "Profiles directory does not exist creating it now..", output
      assert_path_exists testpath/".envio/profiles/brewtest.env"

      output = shell_output("#{bin}/envio list")
      assert_empty output

      assert_match version.to_s, shell_output("#{bin}/envio version")
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end
