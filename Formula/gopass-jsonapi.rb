class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/releases/download/v1.15.4/gopass-jsonapi-1.15.4.tar.gz"
  sha256 "d75b351813f12fcf6616f384070118bf15a26179939fa4cfd7abdf570a7468b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "976d44d96289e8b78a6bb73e614dd91dcaa093ac3c74e5e089dfac820f57a08f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "525855818e0f1d2601029620389f67c87419c29891b1b3e186a0e586a25dd63a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7dbac8abfa406087395cb505f38263fa50dac882e50d40e8fd4e34485cf81501"
    sha256 cellar: :any_skip_relocation, ventura:        "37993983e7269d68480598a63336b81b8c88ec5a05ec9dfa8a40d1a021898e39"
    sha256 cellar: :any_skip_relocation, monterey:       "3ccc08e84bbe468ae7ab91f0fed235dad2095170daa59615920dc0fcb8f8eb8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "33cf89a62c696c85e1b9c090a848ff1bbd1a38d2c80a9798b2a42e53fa380e2a"
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
