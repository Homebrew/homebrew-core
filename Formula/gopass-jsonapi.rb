class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/releases/download/v1.15.1/gopass-jsonapi-1.15.1.tar.gz"
  sha256 "b3463f74c563f8220ef9714c660b52eeff88de3ea9e461f46928241b28e565b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e5f176b2b27feec0a42d74d56c60100301aa545647edfdfddbfad2fac68bbf4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d467247389f2fa7a7ebd51ab6377b71c2a61dff5e508a2a850b3eeb3842cf6f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5db16691d23699c7803fb59ce3c6084ee9bda71776a3b57f3d38f4d8cdb3016d"
    sha256 cellar: :any_skip_relocation, ventura:        "04dd7686218359670fcedfb0cd797ee1d4633a0e07c30890158e8b290cfe1740"
    sha256 cellar: :any_skip_relocation, monterey:       "1cecdd6e9d9bc248f49beefd849df0f4db156f44e77ab4f48939d9098fa17fc7"
    sha256 cellar: :any_skip_relocation, big_sur:        "18fc8979b485db94cfecbcbe0e5154544db20bd863a1302e7ed4794837a65a36"
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
