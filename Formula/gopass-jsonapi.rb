class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/releases/download/v1.15.2/gopass-jsonapi-1.15.2.tar.gz"
  sha256 "2e86b4c1705d7edfb86419549c7abbeb1cc94037e5b2d92ebcfd3a98c4538d93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdf8fe332bc7603077f1b8b34baa7b96821cea71f1b841e8b45d2af34fb91abc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d3361c120926afe74e423c8859e5dc46e1eccad062d2757457bf81addf45199"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc5c04288ef03d6e3160e645f7016191844f8b249d2c27197bb90d0938b047b0"
    sha256 cellar: :any_skip_relocation, ventura:        "953980b95a3f530d92cc18871cca016845a2e337d35852b2097f5061d72d0fd9"
    sha256 cellar: :any_skip_relocation, monterey:       "c302701b769c9fe5801710182ab814c37623207d1fc66bfef11404bcedbaf98b"
    sha256 cellar: :any_skip_relocation, big_sur:        "da5d7626991943bdd505287b50bd13627c1202e29ba06f9048caa00c718b9229"
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
