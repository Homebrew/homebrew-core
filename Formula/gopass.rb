class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.15.1/gopass-1.15.1.tar.gz"
  sha256 "0418700a9540997d658166c9a6b97361e7d6e6e0d83c6a347bc69b1b4533bfcf"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a875a7e26f87f5fe5f70e64b6cdfa97b1942d3a15b154009616da4ef66f58b2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "989cddd70b21375faa6980437a929263c37870a54f97afa108acd15bac41927c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e453e4069ce35bb1f0242b200ad5cc2a0cd870b2c2d8997b0d89e8523932373"
    sha256 cellar: :any_skip_relocation, ventura:        "dcfbe460c5d001f1ab8ff03cb7bddadb3abef96d3cdfc50f382e1d1814e28ded"
    sha256 cellar: :any_skip_relocation, monterey:       "e780e6a8b9abafc092adb07a9ed5339638993bad4391920383d05e48e1b1636e"
    sha256 cellar: :any_skip_relocation, big_sur:        "83441d3d789c32492d374bcc7003276b9ab54a0cc7428e2927e1e007f20a1fa9"
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
