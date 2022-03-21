class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.14.0/gopass-1.14.0.tar.gz"
  sha256 "832aabe92da82216b77af5745e10d24a4edbd50afcfc85b5ef2221353ca3cab7"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfec55ef0e25dd099968015b388040ed66aa08dd6cda14a9543378e1f135428c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d85290e894034c48b37e68fb535ef6d7e704d8189ee85829482f2bf65fcdefae"
    sha256 cellar: :any_skip_relocation, monterey:       "e06660691da28415d7196ed68023f17ca81f20066428ca3d2d435d5540f46edf"
    sha256 cellar: :any_skip_relocation, big_sur:        "73fa712790bcabf1bbac670860b62c3cdd8fb68fde77b4294578c5a5e1280e6e"
    sha256 cellar: :any_skip_relocation, catalina:       "ba6ba6de4cb9a7595ec441f1ea4a956c4457536700eb5a98bd24c990f1b7ee9d"
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
