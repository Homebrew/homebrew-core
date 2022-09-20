class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.14.7/gopass-1.14.7.tar.gz"
  sha256 "443de8190da2913033fe0a18ac0aee41155a9f004a6f608675c99de850a9e03b"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28ae2033449782ebbd91092f13aa0dc9eb6177f26802dd425c979e0ff9d7b6df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4017e7dd3d54fae2ef195551b3a2fc13d3c0be46d64d3cfdcd68ead59b9224d9"
    sha256 cellar: :any_skip_relocation, monterey:       "947e84888959fa8eb44525582848a802f039ee655a653a2041b8744a60cf516c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f3ba5ad4c02679226effd423262cabf5d4fc8785b163b184906aae07d8f2024"
    sha256 cellar: :any_skip_relocation, catalina:       "b63c548af12cec17b34b0b1348c46f76121f4605b519e07717dc213e41de0a7e"
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
