class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.15.7/gopass-1.15.7.tar.gz"
  sha256 "a836a6beffe19fe394dc18e6aa333c93a8122d60e63ee07e18b2c10878efadfd"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1e27e6990ef4b7133eca2dbe81f8ab5bc6b6d74318535f16cfbc0e476c6fc9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c89742a801cf634442a422a87d4697d45aa5399279315f18af4129f8bd4b5208"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a9e762272a90f804aec0bc98885cf71aac8c24a38419b9e9944659c150527dc"
    sha256 cellar: :any_skip_relocation, ventura:        "0dab0983954fc239356bc4c153640453f7b9881940db346815c764d5dbaa660e"
    sha256 cellar: :any_skip_relocation, monterey:       "5abc039557d2bd6e932e4ba6074827bb59945f0f3b20f246ce673f2f05ba12a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5316ff61e8f6200b33f612d21cfa51e94875c7325e27fa8124f0447db1bf494f"
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
