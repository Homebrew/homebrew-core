class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.14.2/gopass-1.14.2.tar.gz"
  sha256 "2b9002e6524c03eed026feadfc7915f94ada9279ea8d5a3a3cdb860186dc57af"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62e0488abcbb882fb436ec817a5d9e844b656dfb356418a24623c35f0cdd121d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21f5f25835711f5b3b633a52ced70fdad94b03c3bd0e73996c2d13fbbb862dd0"
    sha256 cellar: :any_skip_relocation, monterey:       "0a08f776b29baa969f379332df9279936a67794920e785ef611699ae6c6d1ffb"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d9a276e80ffe4020c4343ca4d6675ea5b94f516ba4a7cf72e9095eb1d8bbe48"
    sha256 cellar: :any_skip_relocation, catalina:       "e9f89274bddb382f1b0c38e0aa1a1279e1f89c4a7a3dab3b5d62796aea0ae47e"
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
