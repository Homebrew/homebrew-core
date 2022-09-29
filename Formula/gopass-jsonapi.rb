class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/releases/download/v1.14.9/gopass-jsonapi-1.14.9.tar.gz"
  sha256 "758d05fcb5493e8c0a0063d8504be299ad3d9beacfca6e55a5ba9c98d1f86fd8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a58c0504aa3cbc5029845c455f0bc39a7e216d1d5c202bd3a623485e357c871"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f04dfa4789e1c22b120b32ed5013297d791b1c915555c4193b17d3196a33a48"
    sha256 cellar: :any_skip_relocation, monterey:       "41f566288712b19eef4ea5b388ad8de59b464ee9956b0c5c7ad06819588ac3f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "efb3f56f8d6681c297a99600156146053b471c024b97283b31d05a4c37605bd7"
    sha256 cellar: :any_skip_relocation, catalina:       "c9961baa9765c931bd60fdd25c1489edd9cf6f2018d3242421e0cdb1d8295726"
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
