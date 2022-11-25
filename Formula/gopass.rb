class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.14.11/gopass-1.14.11.tar.gz"
  sha256 "cd0fd946e0ccc8781ed2087f3d4a4d18facd4cb0b2b6d20d3403c766379afef9"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ce91927989d5ae825818b937e3635e22ca0d9e732578aa6a7bb7d23968076bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b52a47f08a4b0d033d4119ca9313c41837387abbfb9adb3829d7040ded2365e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5b8e1dc664ea7c8db5d8bccdcc9bdbc1971e661f44975558ebd4c0e58d92d57"
    sha256 cellar: :any_skip_relocation, monterey:       "1aa60c33165668c430726850c906035fc3228213e07ba239a857a1fb7220f030"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e0fed85f4205c75d57bd3fd68718e78dcc3c4134c903fd5f77e383b461e1d8b"
    sha256 cellar: :any_skip_relocation, catalina:       "9a02e975813ee6f8b574e8997052ee82d28a6120d6be466c1cccd24422e68e59"
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
