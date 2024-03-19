class Envio < Formula
  desc "Modern And Secure CLI Tool For Managing Environment Variables"
  homepage "https://envio-cli.github.io/home"
  url "https://github.com/envio-cli/envio/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "d0009a19dc081d3e7e1b36e8e9fdc29f675d8ac80ddd08565777e6b7d7a99bb1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/envio-cli/envio.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3210967aeb023bebaf7821b7ac27c1ff1775bc46745109b49fb519ed4a8abc9c"
    sha256 cellar: :any,                 arm64_ventura:  "636e7053c01dce88a72b925b30a718318dd3cad5beffc54182d79e7bbbbe140b"
    sha256 cellar: :any,                 arm64_monterey: "9edd1d838e14c436423b94e56839e8138281c895a59b297507b6d0bc21be3fee"
    sha256 cellar: :any,                 sonoma:         "20813b09153aa1ecebbc51fd62f1f6ef6e242535e94a139de8a9f7b4e3a657d6"
    sha256 cellar: :any,                 ventura:        "6316547931cd2f68826260c789efe8f13699a73a84af76005d282c76dec8d0dd"
    sha256 cellar: :any,                 monterey:       "413ac92043f661fc9cb9d1ba900245001e87664f0c87389d7ba0eebfb5091f74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffc838da1b8bcfcd5f4cfa0396f44d1a8e4193612651596910128bbc0bd21bac"
  end

  depends_on "pkg-config" => :build
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
      assert_predicate testpath/".envio/profiles/brewtest.env", :exist?

      output = shell_output("#{bin}/envio list")
      assert_empty output

      assert_match version.to_s, shell_output("#{bin}/envio version")
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end
