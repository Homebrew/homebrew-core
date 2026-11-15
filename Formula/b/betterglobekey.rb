class Betterglobekey < Formula
  desc "Reworked Globe key for faster input source switching"
  homepage "https://github.com/Serpentiel/betterglobekey"
  url "https://github.com/Serpentiel/betterglobekey/archive/refs/tags/v4.3.2.tar.gz"
  sha256 "34e920e9a72bd403f33ffaeb01913765b92e2126ccc3f468fff61db6d93e3951"
  license "MIT"
  head "https://github.com/Serpentiel/betterglobekey.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "53378e9a7b3568af2d8dd937b26f3093ea6857a6c84a1e5f012758477d55d93c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9c4fe7be4741b74ce7cc33da23aca66147e578da2fb5777ddb3651db44dc6e87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "131009dd80247ddbfc679b0cfebd042d40fc695fdc72c0bec66d560e39315edd"
  end

  depends_on "go" => :build
  depends_on :macos

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
    generate_completions_from_executable(bin/"betterglobekey", "completion")
  end

  service do
    run opt_bin/"betterglobekey"
    keep_alive true
    log_path var/"log/betterglobekey.log"
    error_log_path var/"log/betterglobekey.log"
  end

  test do
    list = shell_output("#{bin}/betterglobekey list")
    assert_match(/^com\.apple\.keylayout\./, list)
  end
end
