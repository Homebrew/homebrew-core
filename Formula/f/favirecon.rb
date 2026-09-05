class Favirecon < Formula
  desc "Uses favicon.ico to improve the target recon phase"
  homepage "https://edoardottt.com/"
  url "https://github.com/edoardottt/favirecon/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "61ce4ceea1a11e1e39ec67dadafb4cf9b9749d18385a76774298e5441eca4391"
  license "MIT"
  head "https://github.com/edoardottt/favirecon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f952cf541a0dcedbdbb75991f37df53d8f9dff1ab81ac5fb74c399dd0282045"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2086bc3f6f381a8c80bad321056bfeadd870b6e8dc71a47656911e2b6e2fbd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63844e460c7f7701c1430a9c3b549843f07675b9b8ca51f0ea19f30bb603af66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4152c2b6fbc965f34d857b2cc1acbae91566d4e3fb0384c19c602d49a0220455"
    sha256 cellar: :any,                 x86_64_linux:  "62c824e47d411a3f15503f88b0a76bed38ccffc7c934006d1e0bb7f442b96f49"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/favirecon"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/favirecon --help")

    output = shell_output("#{bin}/favirecon -u https://www.github.com -verbose 2>&1")
    assert_match "Checking favicon for https://www.github.com/favicon.ico", output
  end
end
