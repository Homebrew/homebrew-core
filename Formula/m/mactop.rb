class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Go Lang"
  homepage "https://github.com/metaspartan/mactop"
  url "https://github.com/metaspartan/mactop/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "34c8042bbc8ed7de5f8a7bab261d38f82135bde813a7ebff461bde434aed0cfc"
  license "MIT"
  head "https://github.com/metaspartan/mactop.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "585a8dc8b8a42f0dd495f7e1cc33e0d18f102f2a955f209f97e33b2efce4d132"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "497b9ccaea554ed30380f1989d71de9846bf36a3d07088b29adff39ab3f75d15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa5602315a848e19656f1b7f890159e38b3ff0aa97864913cad4642c1ea40219"
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
