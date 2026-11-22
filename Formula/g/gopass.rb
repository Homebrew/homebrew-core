class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://www.gopass.pw/"
  url "https://github.com/gopasspw/gopass/releases/download/v1.17.5/gopass-1.17.5.tar.gz"
  sha256 "b5f335af9a52af3844eb04ae2a983d36e126da5199c66c83705fc95b0b1dd967"
  license "MIT"
  compatibility_version 1
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    manifest_sha256 "b9a1e8ee5f95762178781b914abaad484961beb425948da7aa99f6e5796e849d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9e4193d2040d48858ad376745c1c12ebc918772a1c198c3b611e060e362b010d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7394dc97d63ec9b04e4eb5c001e1bbce576f625ff5bda670c1d8f75c839c1bf7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "86218b9cb038f9bc2f9ea8bba4f184cec3a3fc40eb6967477dc5dec07bb3fba1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "43555184d04fdec2d66ae3bacb5b31b5ca25089ae48bd0f83630c537f89cd422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e62b1e7c0bad6617afb54f8e654794d8e8d889a5e20a6795ca91aed7d4115c57"
  end

  depends_on "go" => :build
  depends_on "gnupg"

  on_macos do
    depends_on "terminal-notifier"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
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

    (testpath/"batch.gpg").write <<~GPG
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    GPG
    begin
      system formula_opt_bin("gnupg")/"gpg", "--batch", "--gen-key", "batch.gpg"

      system bin/"gopass", "init", "--path", testpath, "noop", "testing@foo.bar"
      system bin/"gopass", "generate", "Email/other@foo.bar", "15"
      assert_path_exists testpath/"Email/other@foo.bar.gpg"
    ensure
      system formula_opt_bin("gnupg")/"gpgconf", "--kill", "gpg-agent"
      system formula_opt_bin("gnupg")/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end
  end
end
