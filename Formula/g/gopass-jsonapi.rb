class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/archive/refs/tags/v1.17.5.tar.gz"
  sha256 "1c04aa5497c8597a4caa689387ee4e625575ad3db82a1ff89f9d57f75eac1c0a"
  license "MIT"
  head "https://github.com/gopasspw/gopass-jsonapi.git", branch: "master"

  bottle do
    manifest_sha256 "bb91bc6e9c8004c8cd50d5e0d5ef68089150b749d043e0a702b05ca75e5c2e6d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "201bf2f309db0ee1f2bfbd744d6adb42d689263a482d7524127fd3907134e0f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aee8453bd9b1ef5c7e6116ee0b15923d7b8eae66da20583634b529c9b9fce1a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6e922206f6044877e6409ed780b4eb4522db4ca2a4565bb24f3986e779235d0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "63c9a10073b972b2655eba80222bfc2b75dd7eece29a87f96c26228e9d2477e5"
    sha256 cellar: :any,                 x86_64_linux:      "acf4eb62a092f079253cdcde78f6efc172fd0594586a167c6b56547eac0d725d"
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
