class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/releases/download/v1.15.5/gopass-jsonapi-1.15.5.tar.gz"
  sha256 "62d8df839014bad51d1b791837bc8348f7fdcafab0d04f0b7bf2b5d6f0dfc789"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2144d6478f58e8a2f3445d0df39b113d010e13d34d5e3ac2d7577e9df0d2e678"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24e6056d727c53c72f9a99cc4777060cb98401f94210834f55fcb5ed8206fa91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b16dcd697d2f3f46a427b44fb3a8e16c159e9260f1c406be48c1d7c5ab5e3ac"
    sha256 cellar: :any_skip_relocation, ventura:        "184be6e31a1a355e872bc8148da6ceae2495957f4c0bd149cada086e8c5da34b"
    sha256 cellar: :any_skip_relocation, monterey:       "9830a062979eb88c428c5aa5375bb20d2a5b0f7cc4d9935c1c3fb7574fbb0318"
    sha256 cellar: :any_skip_relocation, big_sur:        "65626fee34841070b540c0cfb328b5d4531a463a7c11983febc96a065d9fb604"
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
