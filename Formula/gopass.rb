class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.15.0/gopass-1.15.0.tar.gz"
  sha256 "afdc424cfe2b0c29f0cde616f3eb233e6dbe3787741582449de0c90314ec1e29"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d661507642c80a046fa6b3500da8f3ed0a3d6060e5737e4fa5a2f44f6d03179a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0a72d58706cf468a19280615e40a3b55cece1538ad436e21a042e1a42674fa5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f5326f4e7d54808021690ea28a25efcb708c09a711a23376c8deb6b56f5a423"
    sha256 cellar: :any_skip_relocation, ventura:        "b31269ee3519fc4e90e0995077ddbb6026566d23ee478477226fee9b9a2fe1d9"
    sha256 cellar: :any_skip_relocation, monterey:       "5fd5c2be3752e20c205ca3b666099439c915fd2cba9ee13b87faeec2197bc682"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8f3ce162b523b3d3cc4c9e70038188d899d213d46f640593f83497d787970a1"
    sha256 cellar: :any_skip_relocation, catalina:       "dc59e6b403d9d81f8c2600b42cde5a5d54a88cf67cf4d67ec08fc57dbb591bef"
  end

  depends_on "go" => :build
  depends_on "gnupg"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}/"

    bash_completion.install "bash.completion" => "gopass.bash"
    fish_completion.install "fish.completion" => "gopass.fish"
    zsh_completion.install "zsh.completion" => "_gopass"
    man1.install "gopass.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gopass version")

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

      system bin/"gopass", "init", "--path", testpath, "noop", "testing@foo.bar"
      system bin/"gopass", "generate", "Email/other@foo.bar", "15"
      assert_predicate testpath/"Email/other@foo.bar.gpg", :exist?
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end
  end
end
