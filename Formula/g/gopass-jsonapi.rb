class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/archive/refs/tags/v1.15.16.tar.gz"
  sha256 "8ca561234d700b0b76206b90a053ad3da1daa3fc7fdb47837afae8891610b264"
  license "MIT"
  head "https://github.com/gopasspw/gopass-jsonapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e70311e42c120d8efb3eb0eb9e8d6ae8c9265881054b923628e3b3beed1137e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6116c3624ef9a88a596d8476fd998c684ee916f33579d6ec289f5810e980e3b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c75f594eae3157cfd6baad3c358baca8b15d0992306c90a1d0a3bc997d1b2d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aabb32246b7ca6c337cd23aa702d41fab2d7765526168affc8dfb2dfc1255203"
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
