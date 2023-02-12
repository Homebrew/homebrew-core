class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.15.4/gopass-1.15.4.tar.gz"
  sha256 "6f94c935c2f5b31b2c00dc44302be6026ae5fdd4f6fb390b5fba2f5740667100"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57c6fcfee3cd30eb15500eae75b5d5bd7047e6061a2558ca188df654819db9b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f16e2dcb2013ded488c9550471b3ef9cd35c388b9532c723bf28e28974f82be3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "954c7257752a18210a2b8f090a2a8e869477aea0325120e8a8d1e315ab50ec0c"
    sha256 cellar: :any_skip_relocation, ventura:        "fa724f5ae5c325ae9f10deda36caa70588b8cf70d7025e324747f5c77fb7dd7e"
    sha256 cellar: :any_skip_relocation, monterey:       "4f9e7a754871cfdc8d6ef9b914108f61ce79d5080282aa609ecc7436513181c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "04248028c85a9dce35913f8cbec256ebcfc9a615fe3c84bd6fe9e89e48ccb1da"
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
