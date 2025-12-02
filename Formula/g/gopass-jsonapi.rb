class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "a81c64a44278b30026e42b6289678c1a4765dea8a97753cc33c09f0b7dd24aca"
  license "MIT"
  head "https://github.com/gopasspw/gopass-jsonapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3ca745f06dc1ca9b53257a15caa80a3db3b7aa8aa784fedeb7da8b1aa90d1dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c89d0e9f390c1c91d1dbff0e868e868d24c77ec60883094434f5de298be7666b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78f982f4fd548f616546a2dfe445e018e4f4437f85fed435d2c4b97189a0d10d"
    sha256 cellar: :any_skip_relocation, sonoma:        "da5b16e0648b8a5563df056220c5c1e249f927b0a563cd0f0d700688fbc3c186"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "376a7aedfbc6724dc731a12de32f2405a55a22e1e7707fde8da98c773aa2bc24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f57f35e7988d9018de88230e1a8b88e96f392f5fae7e3e4861147e3c1e431aa"
  end

  depends_on "go" => :build
  depends_on "gopass"
  depends_on macos: :sonoma # for SCScreenshotManager

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
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
