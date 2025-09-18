class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://www.gopass.pw/"
  url "https://github.com/gopasspw/gopass/releases/download/v1.15.17/gopass-1.15.17.tar.gz"
  sha256 "2b1efcca1029e92b7cab481734873e8afd86bac382951649a9ba8733a2c22d9a"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6616c81d76f3aef8dca47d82470c06b225e75574e8b76d08dbd0f66d14470071"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c7310af0e02f1584e26636e4ebb89640bc01096c05de3d704549de75375c85a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f340c532d49ab5fb50c49f81c655dc54b7da08bd9162e2f5b19b6ed02f9501cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "45492a5ec63e8ad37fcbd0f016c14efb89f6b91da4085aa31b8f83823c56b83c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83af4b94ed70df7c379cacca0632c2ecc303b79a9d2c4a529ec7b7c59fedb4c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecfcee7108c862dad9ff5aa286081bc8d8c35857540542712951382ae8acdb55"
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
