class JwtHack < Formula
  desc "JSON Web Token Hack Toolkit"
  homepage "https://github.com/hahwul/jwt-hack"
  url "https://github.com/hahwul/jwt-hack/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "85c6d8ade6f60ccafd12283c82ee1368874bc00af90f11fcad8f252baa197374"
  license "MIT"
  head "https://github.com/hahwul/jwt-hack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c774db25ff55344e74cc44cdcd769585185762a3acca17d019df869a31a22608"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31a48a4304a7337ca72b58b72b1b2b0cb33ee41e3b541644891bc53f085fd020"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de06a8f2fd7f055d5b4d3eb815d2d75276a5c4967abd8b74670e739e1961eed2"
    sha256 cellar: :any_skip_relocation, sonoma:        "eac5190ed5651ff1b4c9912ab71bbc28048d5b47b6f4d517462f3c7468cd722f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf4553cbc30e92a05ccff655210d1bf78d0b489d89d039480f673fd2c6245693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c1e09b4e3dfd12d38c0f9e09a3ae9b48418a04b20be9f0c25a74704bd9f12e5"
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
    assert_match "valid", shell_output("#{bin}/jwt-hack verify #{token} --secret #{secret} 2>&1")
  end
end
