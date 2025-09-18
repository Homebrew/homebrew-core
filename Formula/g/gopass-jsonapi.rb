class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/archive/refs/tags/v1.15.17.tar.gz"
  sha256 "cb46541413e52297cb7e3f5acab6206cb4bba3dfd15f6b72988a37f70a2f60ca"
  license "MIT"
  head "https://github.com/gopasspw/gopass-jsonapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fd2829f8e5b72d5077b10096150fd475e98477b97c94c374edc8f31a833ea64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9aba2bbb61ef265fd2a0f62edd68cada8c5021dae670bea31cd63f9f86d4d68c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3b899ac66409c3ca66a9de4828fc8221f33f8be168c131a11b5391c13e576b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "485f7ddde54fc6b1d06e2efbedc4d7f35eb7201d2191f033a3ed1743f34dbea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "146185df443b509b601ec7450487c09b8eceee948b2b8ce8999891c69f6bac17"
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
