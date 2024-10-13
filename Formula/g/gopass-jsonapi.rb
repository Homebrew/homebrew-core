class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/archive/refs/tags/v1.15.14.tar.gz"
  sha256 "2ff6a1b03d5b7befe81d6465990ea5b13b9ad052d6c9cf1638b795767307d9ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9faebf571426dabdfb566614961123daab44eacae6b4cd7593e54347621be5ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f16a5232c13d2ba977dd043b0f507c86c9c876b826687f89fe3ad884ee77b04"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9d8d8f1c501c3ea65d500696775286246a84edc5d85bcf56d8c1be13b24594c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64cc4724a4a0ac92dae382d952b92f31835892269d64e0942228787bd1d60ca9"
    sha256 cellar: :any_skip_relocation, sonoma:         "9341168b05cda035be152b94dd3659de2126226f0b742df82a9aaeeb1c65d417"
    sha256 cellar: :any_skip_relocation, ventura:        "c99fa5c3240121fdb17a547eb3db32d12e0375eb12b767b7331055516709cde3"
    sha256 cellar: :any_skip_relocation, monterey:       "984ec10a8134bb0a33a0338ecfd2425d2a011ebe83ed3a8fd60e435459ca4fc5"
  end

  depends_on "go" => :build
  depends_on "gopass"

  # update screenshot to build with macos sequoia
  # upstram pr ref, https://github.com/gopasspw/gopass-jsonapi/pull/130
  patch do
    on_sonoma :or_newer do
      url "https://github.com/gopasspw/gopass-jsonapi/commit/bcab9c40e9dc63c39bdc45c91a534eb34d95a8dc.patch?full_index=1"
      sha256 "29254a57c99136d1bfaa059d497e6b3e7e7e6e3cf495e584519c6fe7291f7d49"
    end
  end

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
