class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Go Lang"
  homepage "https://github.com/metaspartan/mactop"
  url "https://github.com/metaspartan/mactop/archive/refs/tags/v2.1.6.tar.gz"
  sha256 "5dd47033c00a56859674c149a90118ce39c7a0c5e1e30cefa714b71f943dbf47"
  license "MIT"
  head "https://github.com/metaspartan/mactop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c7fee08638a11e9845ed401c8b4052fb008c4d6411b919dc40e9c392dc44508a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "022a630c6fc8b62bc628f3175a441880cf294947dcbf7627bdb7102b7448731f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "54e8c7ffde9b4211a22dc356607f298f6894a3627a67327f4482ed0a15b19a3e"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
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
