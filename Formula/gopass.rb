class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.13.1/gopass-1.13.1.tar.gz"
  sha256 "45a98b9057cdb5924c65a56e13dd4587842220ab117809579f4b2a23dae8b6b1"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3587e2e88e01175e3fa73c103c4f50428940f6906a3f3dad6984607cfb4b3134"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5de403b19064c98d0fb0e0a1fc670120df648948208080658f84ed34f7e11f1"
    sha256 cellar: :any_skip_relocation, monterey:       "a9808fe3c3fd7b8b57140d21a434b8099cb3c1f8f9a14c6c91abbd5ddc52cb9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c7a4bad9b2903edc69d25e5faaf870cf206fea770114fb6296b246a8fa69519"
    sha256 cellar: :any_skip_relocation, catalina:       "3c96913d714f532eae8ada362adf6a10f350ca8a763748d4019ac763060dab97"
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
