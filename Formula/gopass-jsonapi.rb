class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/archive/v1.14.3.tar.gz"
  sha256 "64aea30cc1473bce81e80e407bf2911b0b67d08dbe17321c729685f847904259"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f0a57a10c3937ac49d2423a204af548085fa66000960de0ed87be1c19310858"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91ab2a47382056f315aaf002f154a8803d95152cf6bd94967ccaac50197d7e10"
    sha256 cellar: :any_skip_relocation, monterey:       "ccfe9413ab068d1c4b8eba1caafd34d17138643e071e703a455b1c61c0b53103"
    sha256 cellar: :any_skip_relocation, big_sur:        "c342264dc7edb0e70cbcd7d2daf4703197c4e0b1d6639a0609629263f344c8db"
    sha256 cellar: :any_skip_relocation, catalina:       "c56024144b871ebdb0b14ac9d64b1aab63de8f4d55bc734c9fb8588dc3d7bc4a"
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
