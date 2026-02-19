class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "73449a7c359836a995946e54d91e32afe5a54e1519b5a01f78c9923c13c0894f"
  license "MIT"
  head "https://github.com/gopasspw/gopass-jsonapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63e40f2563f43b12908bdb89509d8b568ac3e797fe43d1c0bee05f56bcd4aa2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6cfbfce7315db8f388249ef66abdc19f71d996d69ab699e1bd0a48ac66dc050"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8c19bd6e4f571996fedd915472e0ce7c37d859c856610620f41af8676bc4351"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff59e9b4d90e3bf9d5fe694477827b7b6676f21ba75fc1ca00d63fa4c56a904c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4da1e2900218d466f4e58fa97948b8d19e0dc20078d503b06bf0406415cb176f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "497f201696c8c1e7d5098e55e064f5537c4ace06a40eac22a6ea6f552dfb94c8"
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
