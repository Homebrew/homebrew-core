class JwtHack < Formula
  desc "JSON Web Token Hack Toolkit"
  homepage "https://github.com/hahwul/jwt-hack"
  url "https://github.com/hahwul/jwt-hack/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "1b80213f0c8e8a2e8d50a8fe1f9175fd777cba1547a56f163ab6ccf9d29a1b20"
  license "MIT"
  head "https://github.com/hahwul/jwt-hack.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58ac1d62e95f5bfddd19b7b1273e937b63bef9f6b2fab69194503520a2b31bdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fb99a1bfe03e19a8088f0f3f0e4aba346e664a9cf4276da966ac0d794c2d9e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3ff8df05fb3ffd10e4c5c0dc79b47b3fad162cc86797004fd03b76f4434e65a"
    sha256 cellar: :any_skip_relocation, sonoma:        "02e8f0d957a03cc263bdd2d09d218b8b35dafc4447bd0efe492bc5af4e9c583c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8715a9760ee5da2cb9e0ec0aacbb9f017d1a79569e1c4c423dff3a9852286b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1769eb46caf2738517efbdaf4ea2eb94d1a9266c850f52f39a3a23cea7a6f83"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" => :build
  end

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
    assert_match "valid", shell_output("#{bin}/jwt-hack verify #{token} --secret #{secret}")
  end
end
