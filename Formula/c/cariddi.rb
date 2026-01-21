class Cariddi < Formula
  desc "Scan for endpoints, secrets, API keys, file extensions, tokens and more"
  homepage "https://github.com/edoardottt/cariddi"
  url "https://github.com/edoardottt/cariddi/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "b29bdb7e03d002b04abc13cc7cb40089aad22ba8315aefcb1d38af1b665097d0"
  license "GPL-3.0-or-later"
  head "https://github.com/edoardottt/cariddi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1567c8ea44905b59e5573ef3b985d8435de0ec04142a922bd9075b3471999e1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1567c8ea44905b59e5573ef3b985d8435de0ec04142a922bd9075b3471999e1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1567c8ea44905b59e5573ef3b985d8435de0ec04142a922bd9075b3471999e1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8659f20d5a386c128bb0032b05fa80b90341d7c8abd4077382e0261d99181139"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dc1e4f046d0bf61b1a41fc46487e30861a77eb4a7e45c3db05845db1af7d002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0864ddf6c8669dcd49a400213d6e2bf2d0a10dc4b5d4655fead6d91ae89165b3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cariddi"
  end

  test do
    output = pipe_output(bin/"cariddi", "http://testphp.vulnweb.com")
    assert_match "http://testphp.vulnweb.com/login.php", output

    assert_match version.to_s, shell_output("#{bin}/cariddi -version 2>&1")
  end
end
