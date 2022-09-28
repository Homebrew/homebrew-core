class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/releases/download/v1.14.8/gopass-jsonapi-1.14.8.tar.gz"
  sha256 "af55da764143ae6fd4865bd4a82500dc41138c101a16f2df55785655c4d20295"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88c4d84ef18fd7e2266db1240a00155c0565b0644bd9cdf8fcf47e3fc9bfc750"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39a3b83171034bd32f8bd96b5b923f820a85ee400a882d2ed79fc12243155a7c"
    sha256 cellar: :any_skip_relocation, monterey:       "985355d7038db28d8cdec5ae959b9568b3e2adfe3030e9f4604dc024bed13a0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3777bbd580a439d904dc8b420568a4257dc6427ed37c98b0a71c9ac8542956a0"
    sha256 cellar: :any_skip_relocation, catalina:       "6cad3a3d862e630d18f790875c88b6cd106c57b07ea397a74178e96647848455"
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
