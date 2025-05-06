class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://www.gopass.pw/"
  url "https://github.com/gopasspw/gopass/releases/download/v1.15.16/gopass-1.15.16.tar.gz"
  sha256 "058db6b24221864b1b9879d10a91a3ccaeef8a3da269898c7936ae257d7da5c3"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5d6b11f91dceed0a451dafa4797bbcfacb8bf628115d4357e613db6ae570e30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e00a7e037e5216d21ac4df9e4f4e3799fde10e53f0c53d1aa575cbdf8d38b4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55be93d17b03eee7dbc09cb6ef81563f2f0b3296f0ed415ec7d7217c19c2eb2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "843769e687a522798e7b8c6b7f012104ec3ccc1f5b0b05367cdf991c50e1e174"
    sha256 cellar: :any_skip_relocation, ventura:       "af7a60cd020f108a7c2a5a318bd2a712930ede4f47f2a197ad960507ced32934"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99e86c10fc61251d147ef0dfab8913f8805041e65332bab5eb08bfcf7ac5d503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7170b08deef414db5c16934472e4715c0f8ff6fbe8bf191764bdc6a1cdcc9614"
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
