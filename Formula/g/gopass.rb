class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.15.13/gopass-1.15.13.tar.gz"
  sha256 "3a8ec1462b5976525fa71345cdd89aca90fddb7feab1aec85b9f97b362622593"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28bab1b9f845f95fe264682117bad92a51ae475907a539e1c6ed6b5efbc53fcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc84eb509c2bee9e60ae9a863b48a79bddf82d3dd20dc5c2d6c8f92c8eb34bc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c210565bcec3f047e8c6b2fb91b6cbf15cef8e9c3ad93da60ae2bcfb64ec05b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9176f688253d75daf43aeef65d4851f47a5df203a3d054e1c2444acf702e7d5"
    sha256 cellar: :any_skip_relocation, ventura:        "2bff64d70def3686e14f5fdc19d2afc4ad8ea792cf506a2414935279d0d25041"
    sha256 cellar: :any_skip_relocation, monterey:       "5aaac6c1059ade511bc58952f2cefe73883d7262ef245766ff60bb771044a28c"
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
