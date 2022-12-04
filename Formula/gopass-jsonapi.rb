class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/releases/download/v1.15.0/gopass-jsonapi-1.15.0.tar.gz"
  sha256 "c4b8e1cdfe64010798e93643b6590621d004794c558edd976da8f9b3861ea538"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5995642a3234734e39d7e9c5e13e4c92a7ebddce12b86a947d4bc17bde7b080b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14c39192b7ec1ddd0cf1844ab00572507d01ce43743e736395fe212ff828695b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3de43e66243acd4362e56ba117b5abd294883b26e730a4e76c0f7affdb726aa"
    sha256 cellar: :any_skip_relocation, ventura:        "cf5ca1126b164badf337fc2044396da2db14f96c6a7fdfdebaf84cc0ac80706c"
    sha256 cellar: :any_skip_relocation, monterey:       "f493c674d668a1e00a38896d2aae81bf17ca2df383e60f9dc817a25949c65759"
    sha256 cellar: :any_skip_relocation, big_sur:        "7dd1b409a6273150a1d254e408620d4e23321e5e2255880cc2322372b69ddc7c"
    sha256 cellar: :any_skip_relocation, catalina:       "625285b45df9135f50231165e8f24203f3a3d4a81f81532d44a093814d1170e9"
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
