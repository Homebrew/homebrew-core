class Dalfox < Formula
  desc "XSS scanner and utility focused on automation"
  homepage "https://dalfox.hahwul.com"
  url "https://github.com/hahwul/dalfox/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "6b3b09be44dcfa00e15fded2999ccbaf7cae53b8cfa6ea7ce191f27d6c209c9b"
  license "MIT"
  head "https://github.com/hahwul/dalfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "359843b81c510f220dbf694a4785c082802eb74d742fec10e36ff0e3695bbf53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57a76e8eb3005eea20562d50c14c0a9eb81a4f19a1a78a97014400cab360d377"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6581ee9f8783e656601b13db8332606709c64da77d4ccc6d866f76db9493830"
    sha256 cellar: :any_skip_relocation, sonoma:        "df2b56f0847777c5cd44556e391e149b02d62e6caefd93e5c19526b53b2f5b45"
    sha256 cellar: :any,                 arm64_linux:   "843d23490179ac0e4e3a9ade623444923fd3f7e9da0e1c2112fadb51c5894c90"
    sha256 cellar: :any,                 x86_64_linux:  "1f9dcd5cac15320e1d53bad4f21efcf1efeafc80c8e5fc37a03f70590e7b99b4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dalfox -V 2>&1")

    url = "https://pentest-ground.com:4280/vulnerabilities/xss_r/"
    output = shell_output("#{bin}/dalfox scan \"#{url}\" 2>&1", 1)
    assert_match "scan completed", output
  end
end
