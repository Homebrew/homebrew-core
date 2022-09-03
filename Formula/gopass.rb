class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.14.5/gopass-1.14.5.tar.gz"
  sha256 "4d75fae8d1d1065915c4d5baa5b290362d8ba0a36f3fd48e26708376a29b1c9e"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1052163e1e32938898a794abb1fe90ff4454f7dddcb8930b3d0c3f78bc2533c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b16b4fcabf382b8b424f9f15ff24f9d2fbea5b4a9edb85c9f637ea69a89e93d7"
    sha256 cellar: :any_skip_relocation, monterey:       "6abbdaa26aa3fefd2b111f7211978136d87f39f39879282049cbc5fa7f839dec"
    sha256 cellar: :any_skip_relocation, big_sur:        "934ec918fa0c62dd83ed7c22bad69556d9a554b7fad645b9bafe6100c9cd215f"
    sha256 cellar: :any_skip_relocation, catalina:       "33164cc6369b06bc50ea6dc5bac4005e9669c5d0a78d33107b359f2a87a8fd18"
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
