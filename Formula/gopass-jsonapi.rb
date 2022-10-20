class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/releases/download/v1.14.9/gopass-jsonapi-1.14.9.tar.gz"
  sha256 "758d05fcb5493e8c0a0063d8504be299ad3d9beacfca6e55a5ba9c98d1f86fd8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d33ccae2d44dcd361c74abb236f9b75e43106780f98250b1d96df7adf4ed3f0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7929302fb1f38c263e59319480d8383a281b03e241e3a5536571a04737e6974"
    sha256 cellar: :any_skip_relocation, monterey:       "7b4f06fe30c117903f115caa12c7003c4132e57396e6ba6f937edaebaaee75b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "361cce1f75914245c62581fc99125c8d1c2b241b91946ac8949ef7e25fd97be5"
    sha256 cellar: :any_skip_relocation, catalina:       "b82a33a9775e3170e3e2f933ce295d7c56bccc0e45d4c8b6648e0d9a5e842633"
  end

  depends_on "go" => :build
  depends_on "gopass"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
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

      system Formula["gopass"].opt_bin/"gopass", "init", "--path", testpath, "noop", "testing@foo.bar"
      system Formula["gopass"].opt_bin/"gopass", "generate", "Email/other@foo.bar", "15"
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end

    assert_match(/^gopass-jsonapi version #{version}$/, shell_output("#{bin}/gopass-jsonapi --version"))

    msg = '{"type": "query", "query": "foo.bar"}'
    assert_match "Email/other@foo.bar",
      pipe_output("#{bin}/gopass-jsonapi listen", "#{[msg.length].pack("L<")}#{msg}")
  end
end
