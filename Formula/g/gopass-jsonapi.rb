class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/archive/refs/tags/v1.15.7.tar.gz"
  sha256 "08ec445cc6929c7887caa3c631ab1aa73def89ca35f16160e5ff2ce535a0370b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53429b673061910f87b1ff0d921b097acc03259a5495b6543b808c2c9de26d0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f75bd5d49c117c42d42193a5c7cad8d9a44a966bcabe48ad9393bd5373ade482"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ccbe3a402799795a1c94a807b2c2bb40bc93d2069258a1a75534f95805b25fc8"
    sha256 cellar: :any_skip_relocation, ventura:        "b05842a08619e5eea5eb0ee0766b2b036ceb190a86dacca0b6d1385d9a833812"
    sha256 cellar: :any_skip_relocation, monterey:       "2298de2b7e16857841edd1f191e91d483b438509cf03c31874a6c0ec6de9d11c"
    sha256 cellar: :any_skip_relocation, big_sur:        "29d04f23e958d67998f36d41991022be277669647ed7b9d5078456527858436c"
  end

  depends_on "go" => :build
  depends_on "gopass"

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
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
