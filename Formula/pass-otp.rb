class PassOtp < Formula
  desc "Pass extension for managing one-time-password tokens"
  homepage "https://github.com/tadfisher/pass-otp#readme"
  url "https://github.com/tadfisher/pass-otp/releases/download/v1.2.0/pass-otp-1.2.0.tar.gz"
  sha256 "5720a649267a240a4f7ba5a6445193481070049c1d08ba38b00d20fc551c3a67"
  license "GPL-3.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0708c1697aa6a8a453b0fa2141aa5654a330c483979278f0917922589d490103"
    sha256 cellar: :any_skip_relocation, big_sur:       "5bd301d324d702618b91ad03ffae899e087ab225450c0a24eb40f4cec0b5cbe1"
    sha256 cellar: :any_skip_relocation, catalina:      "515eb09606a7e6d384d81a2cb045189b0f1dbda605f4743cd06f9bdb665ff0db"
    sha256 cellar: :any_skip_relocation, mojave:        "4fd5893adc28693cf5b532d0ad1d469d58842e355d676cb3371c4832ed1e7a0c"
    sha256 cellar: :any_skip_relocation, high_sierra:   "4fd5893adc28693cf5b532d0ad1d469d58842e355d676cb3371c4832ed1e7a0c"
    sha256 cellar: :any_skip_relocation, sierra:        "bd30d129efb90973ffa102df943b0b3f07c47f28cb70027bec07a75d66bfd145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0a96216fb3d12ceda70804c9995aea916716d476bcf9e18863cc84e78558198"
    sha256 cellar: :any_skip_relocation, all:           "b0a96216fb3d12ceda70804c9995aea916716d476bcf9e18863cc84e78558198"
  end

  depends_on "gnupg" => :test
  depends_on "oath-toolkit"
  depends_on "pass"

  def install
    system "make", "PREFIX=#{prefix}", "BASHCOMPDIR=#{bash_completion}", "install"
  end

  test do
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
    begin
      system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"
      system "pass", "init", "Testing"
      require "open3"
      Open3.popen3("pass", "otp", "insert", "hotp-secret") do |stdin, _, _|
        stdin.write "otpauth://hotp/hotp-secret?secret=AAAAAAAAAAAAAAAA&counter=1&issuer=hotp-secret"
        stdin.close
      end
      assert_equal "073348", `pass otp show hotp-secret`.strip
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end
