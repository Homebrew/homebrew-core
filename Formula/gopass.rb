class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.14.1/gopass-1.14.1.tar.gz"
  sha256 "212c87822ecf5d2d16a4d14d72fd9920d24bca803146bb4a305d92d910f7f473"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f4acf3f7f9b9363f08b7d73baad5448e6b02240ab2316e391bcb19e1cd54eab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17bec1ea3fdc523cc04023988ec36ad7f7a32e692b54da04a1b6abc7d23c377c"
    sha256 cellar: :any_skip_relocation, monterey:       "a89fe91bfdc87028b8249c082ce6a27e188973b55a3f01a4ccd4dfdc8aa70402"
    sha256 cellar: :any_skip_relocation, big_sur:        "9327138d8ce4b2d241beb17ffe857ebf422a14c6d060036e96dc15c68cc62658"
    sha256 cellar: :any_skip_relocation, catalina:       "db2101129fe2e3412cd061d89fd10331cfc7299590615f84b29a7b22e372e255"
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
