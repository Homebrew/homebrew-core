class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Go Lang"
  homepage "https://github.com/metaspartan/mactop"
  url "https://github.com/metaspartan/mactop/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "df49979c413b8a3a6e98ccfb553fafeb94fd652ec13a830205d057c8d73cace7"
  license "MIT"
  head "https://github.com/metaspartan/mactop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cd8bcc67340c0f637d6345b0a6b3ca729e6237f6e322e0d90e7bd48a8580a2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a022ad6a6b766891a69ee8ab26956fb0dfe5b163cb7eaefa6032ee2f9f587cfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c97420c5a27f470fc56fda4640f08f9dccfc3c45cecda6437ac12c2efa0f7f60"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin/"mactop", "-p", "9101", "--headless"]
    keep_alive true
    log_path var/"log/mactop.log"
    error_log_path var/"log/mactop.error.log"
    process_type :background
    nice 10
  end

  test do
    test_input = "This is a test input for brew"
    assert_match "Test input received: #{test_input}", shell_output("#{bin}/mactop --test '#{test_input}'")
  end
end
