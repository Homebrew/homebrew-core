class JwtHack < Formula
  desc "JSON Web Token Hack Toolkit"
  homepage "https://github.com/hahwul/jwt-hack"
  url "https://github.com/hahwul/jwt-hack/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "f510ce2a1fb1bb98844536810659c9e310ee6a2e844af9dc7f0b874222ca7f6d"
  license "MIT"
  head "https://github.com/hahwul/jwt-hack.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ca0973e4a1c3bd80d36756df201204607dcd7506d2a4199f53dd566967cfd24d"
    sha256 cellar: :any, arm64_sequoia: "94f3ed531198797ae18f317ac34fd24731c0442f47acbc542594e35e67fcf26f"
    sha256 cellar: :any, arm64_sonoma:  "c4217a906f676b5a2638712385ba8f0bda3768a0ccdb69c5418106c065f15399"
    sha256 cellar: :any, sonoma:        "be4caad94ea906ab332e6a79b536148d2048d402cb76ec726c7d809045c57c60"
    sha256 cellar: :any, arm64_linux:   "76d5a6fe189daa21e3d22638a08c56193a89ca8cbf20567c7d33bd96a99648d1"
    sha256 cellar: :any, x86_64_linux:  "0182c389ff7cf2420a6cebdc898f87fb1442959bf0f437d92056d539dcf96060"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "jwt-hack #{version}", shell_output("#{bin}/jwt-hack --version")
    cmd = "#{bin}/jwt-hack encode '{\"jwt-hack\":\"hahwul\"}' --no-signature"
    assert_match "eyJqd3QtaGFjayI6ImhhaHd1bCJ9", shell_output(cmd)
    token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6Ikpva" \
            "G4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTc0OTI4NzU5Nn0.6Z458qcvAJFTH9XCBgfmwgmqupsrefK8ItGYfyH0Ipc"
    assert_match "John", shell_output("#{bin}/jwt-hack decode #{token}")
    secret = "a-string-secret-at-least-256-bits-long"
    assert_match "valid", shell_output("#{bin}/jwt-hack verify #{token} --secret #{secret} 2>&1")
  end
end
