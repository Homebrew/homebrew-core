class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/archive/refs/tags/v1.15.11.tar.gz"
  sha256 "f72b1c691fa41d7e9a3008d2536255bc7677d4f869f98487be00b82e5f76f3c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76d729fe3e8dd0f9d4abdce58080b118da0e71c41f4dd422bea57ad98c8c073e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67560066d8e8bacd70609b14f1ec57779d89db9874491e7d5e4e120d4daaafe1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af5496b3865bf634facbc18e7a1128a4f5f72edeedfc1dc8ce6d33e783f127ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "41fff3c6e2b3a985bb24208d555500457ec939a9f1174bffe60368028407b64e"
    sha256 cellar: :any_skip_relocation, ventura:        "4b1d7e1563492f3198a6838cc57bf54dc73c08d1b4d450b5cafb2c9e8691f1d6"
    sha256 cellar: :any_skip_relocation, monterey:       "172387a00ceef540736f6fedd4d5edca5cbea747251eff9c59e5769f7d0206f9"
  end

  depends_on "go" => :build
  depends_on "gopass"

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
