class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.14.0/gopass-1.14.0.tar.gz"
  sha256 "832aabe92da82216b77af5745e10d24a4edbd50afcfc85b5ef2221353ca3cab7"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8496b8e93da51e09ce82bd52b15ee741258f1d61d2875a6c9961ae6aac560ece"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8b61baf66bf21a48e7dbcec6c04edc2010cfe836c770cada9e9b38842a30344"
    sha256 cellar: :any_skip_relocation, monterey:       "70493312d4111924a0f9d03350e9e0a4f258e544fd6c5dcaedafab1ef6e7bf99"
    sha256 cellar: :any_skip_relocation, big_sur:        "3519aa6d0f65b16dbc8cba10eeb6ece3517970343fd3f6a034ede3ad4ae4d84f"
    sha256 cellar: :any_skip_relocation, catalina:       "db4a759f0044ef10061a04dda31cd3d4d3d28baa2572b2b31e7b5873566c2c18"
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
