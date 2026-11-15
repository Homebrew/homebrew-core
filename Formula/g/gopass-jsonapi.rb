class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/archive/refs/tags/v1.17.4.tar.gz"
  sha256 "5cc12a3894a60fc3b0233344636638fcb04a0e834912247160e333878a60e37f"
  license "MIT"
  head "https://github.com/gopasspw/gopass-jsonapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3c259afb845fbc8e5e884361414f3dacac2e53bb35ebceec56fa88be03da1cfd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "95764865832ff86e08ed11386a1d110e723e9cdc848e3be409866a921d3cf4e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "64c1ebb697e86364b9156f2c3d48b35f0da92a8bd1ee4c0b333aeaf52f4145ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8a5bec0d40464e1e5024fafedac0788715dd8955e8ca284870ab866d23da0b73"
    sha256 cellar: :any,                 x86_64_linux:      "d403d9e5bf9d85f7ef84cb6dc2ce0ef5432248d6f143bd3357661112ebbc9f1e"
  end

  depends_on "go" => :build
  depends_on "gopass"

  on_macos do
    depends_on macos: :sonoma # for SCScreenshotManager
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    (testpath/"batch.gpg").write <<~GPG
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    GPG

    begin
      system formula_opt_bin("gnupg")/"gpg", "--batch", "--gen-key", "batch.gpg"

      system formula_opt_bin("gopass")/"gopass", "init", "--path", testpath, "noop", "testing@foo.bar"
      system formula_opt_bin("gopass")/"gopass", "generate", "Email/other@foo.bar", "15"
    ensure
      system formula_opt_bin("gnupg")/"gpgconf", "--kill", "gpg-agent"
      system formula_opt_bin("gnupg")/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end

    assert_match(/^gopass-jsonapi version #{version}$/, shell_output("#{bin}/gopass-jsonapi --version"))

    msg = '{"type": "query", "query": "foo.bar"}'
    assert_match "Email/other@foo.bar",
      pipe_output("#{bin}/gopass-jsonapi listen", "#{[msg.length].pack("L<")}#{msg}")
  end
end
