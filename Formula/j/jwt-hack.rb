class JwtHack < Formula
  desc "JSON Web Token Hack Toolkit"
  homepage "https://github.com/hahwul/jwt-hack"
  url "https://github.com/hahwul/jwt-hack/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "c167f595e5552dfbf5bd3fd79e2f061b1ad9d99790ffd036351172997a6de678"
  license "MIT"
  head "https://github.com/hahwul/jwt-hack.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72eecc220faac63e56979a32d8d3df3cfded9aac523544b7635883cbc78a6521"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac32fc1ebd660d5b804b4b3ae99f665b80b0ec8b875f59f9db79440e654b0d7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07347f80da49f98a99b662cdbb1db730462c2a3ea52ac6bf7c0187a485711c75"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6548493fef34eacab72613f6cb5a3b0ad457608c62fa6a3dbae05a3f6e48256"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e845b69463ad7556ffbf99293fcdc8c95f87966ff052a57566ee92562c01f9c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d66d4a020117bff143cb00a8cda7339a7a2e508b8c85dc0a503afa21108abda1"
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
