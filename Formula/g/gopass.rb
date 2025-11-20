class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://www.gopass.pw/"
  url "https://github.com/gopasspw/gopass/releases/download/v1.16.0/gopass-1.16.0.tar.gz"
  sha256 "c7eb08c2b6dc2168aca54b503ef36b9e213107b1a9b8c0d25b11ac315ce8cd23"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e3ea5a1fc68ca352c96b4d36ff301c0afe45e398f70a16aaefc88e159ae1afb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3aeca39cf89b4d13eb52dcb43972c728bd89f9a96aa5a445f741062aa9e261ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "681adc625fed9e862bd4c376799a4a2e7506940427cfafb3e61b75e038f1e939"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff5ad8ded3b2ba6c5dcc21927f832fd778c362f8444ba5f692094e5a8efaf8cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "604fc533da4e33e3ecf912def01550af78e7c8dedd37f4d259d47c5cc11b959f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e811b541fc239426f6992d738df25dbd1b1d4b3ed2052a28219b98025fea42b1"
  end

  depends_on "go" => :build
  depends_on "gnupg"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    args = ["PREFIX=#{prefix}/"]
    # Build without -buildmode=pie to avoid patchelf.rb corrupting binary
    args << "BUILDFLAGS=$(BUILDFLAGS_NOPIE)" if OS.linux?

    system "make", "install", *args

    bash_completion.install "bash.completion" => "gopass"
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
      assert_path_exists testpath/"Email/other@foo.bar.gpg"
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end
  end
end
