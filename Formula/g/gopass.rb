class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.15.14/gopass-1.15.14.tar.gz"
  sha256 "70e66461b872843312897e86208b23e3202c70ee182ad1d2bfda245db9d3680e"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "da43f853ea2c5bd2dec9a797579d833e0c03c853dff0c6d77bf3a0cc21d40595"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "074ccedcbf498e9428b3aa34ffe051bd9c3782e72f6ee5dd0ff6113a0d19a437"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b735453e9525f1bc900f13436fd53310fa83ae0c18ac2a7c50722fbbed3d777d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d2dea9f7da5cf404982b1db827834a98f157e2e0c805d6f3d0030be960965ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "601afa57475bf3645a3f2486d34dca22a28896ae1d629e6f215e6d022bfc6351"
    sha256 cellar: :any_skip_relocation, ventura:        "b892b968cb60306d29bc2320932dfd573063c4c037931b407677156969d46f06"
    sha256 cellar: :any_skip_relocation, monterey:       "5bfae2bd096de6b616bd8aefe62acbb9ceb3bc0733cba19fd1c0832fe4d11cef"
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
