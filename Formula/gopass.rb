class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.15.7/gopass-1.15.7.tar.gz"
  sha256 "a836a6beffe19fe394dc18e6aa333c93a8122d60e63ee07e18b2c10878efadfd"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b27606a4b681d2f1f3d0ba9d3e751e31a1e1824dcc7b325a263a57ab4e0898c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66e83019a2e11b1f252e7421c235cd2e5bcec1b6a35ac547f5ddc6796d6d05c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dabb3a70d9ed2888e1b43cba44a518a870d47846daf25ed9e39f34e485f9378a"
    sha256 cellar: :any_skip_relocation, ventura:        "14b577b7b551105d0bbee175b3f6b29410c1a7528e13a1e4485af029a8290616"
    sha256 cellar: :any_skip_relocation, monterey:       "d302e3601f00e8978b5c5d055c55817252086e4c945464dc9e565a4dbcf1d0dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9f44c8af559b7b301def3c91df46720327d3ab05c91878cf9db2dc4e574eedd"
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
