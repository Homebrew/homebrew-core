class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/archive/refs/tags/v1.15.18.tar.gz"
  sha256 "ab752180583069e05dd2862b6469a515e9df54186085c341ae2255205ab78e76"
  license "MIT"
  head "https://github.com/gopasspw/gopass-jsonapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dc622c202fafaef8f1d6aea8256d822e585e21c0412bdbc3e6350b584107148"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "793561341202549f360e60c949b5f8b6ba15564b2ae054f091d5dbfc537f8279"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a4855f89ae14bdb8eb415558155750c696cd9d72c4187c2f725cd9a5c9f74c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "adbf29cd303e3085f030426616f6f307e51833e020c84157c5636a8028694df2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1a8a9cdcababba0aece7c50d15fc6bd0dce13e2a9e9b3e6c0bc2e9812a148d0"
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
