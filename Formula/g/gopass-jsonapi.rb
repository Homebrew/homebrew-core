class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/archive/refs/tags/v1.17.2.tar.gz"
  sha256 "b1369a2bad432386455d7aa3002f93910f9e275fc3c33e3f37f5731aa918f07a"
  license "MIT"
  head "https://github.com/gopasspw/gopass-jsonapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4dff4ac9cd1dc72f764d824afd28c9951030a18ccb8b001246051dbada51c75a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f4776b2a52ab6fe0a76e08bad6e198b8a2a20ab47685b1fee4f0dea9e9499bb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3316aba51d103cad28b209bda47eae02181766f49e82f41c42c1ff36eb07a0ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "2fc3c9121422b93fd1c8b420567ac2fbfae69186363f252118a348798b41b1e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6eb6b9729f73490d72c16911e0e1461efb6e35f04c8681cd26085653641ad9dc"
    sha256 cellar: :any,                 x86_64_linux:      "f132a16efeb00a969860bcdb269a421d2c75d870d21619e430e533aa6bd35d4b"
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
