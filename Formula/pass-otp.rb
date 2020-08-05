class PassOtp < Formula
  desc "The Pass extension for managing one-time-password (OTP) tokens"
  homepage "https://github.com/tadfisher/pass-otp#readme"
  url "https://github.com/tadfisher/pass-otp/releases/download/v1.2.0/pass-otp-1.2.0.tar.gz"
  sha256 "5720a649267a240a4f7ba5a6445193481070049c1d08ba38b00d20fc551c3a67"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "515eb09606a7e6d384d81a2cb045189b0f1dbda605f4743cd06f9bdb665ff0db" => :catalina
    sha256 "4fd5893adc28693cf5b532d0ad1d469d58842e355d676cb3371c4832ed1e7a0c" => :mojave
    sha256 "4fd5893adc28693cf5b532d0ad1d469d58842e355d676cb3371c4832ed1e7a0c" => :high_sierra
    sha256 "bd30d129efb90973ffa102df943b0b3f07c47f28cb70027bec07a75d66bfd145" => :sierra
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
