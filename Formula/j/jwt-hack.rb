class JwtHack < Formula
  desc "JSON Web Token Hack Toolkit"
  homepage "https://github.com/hahwul/jwt-hack"
  url "https://github.com/hahwul/jwt-hack/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "f2ee0308b694c86d3dbf49bc10c6301c210461a513d857b99f7b96091f736817"
  license "MIT"
  head "https://github.com/hahwul/jwt-hack.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a873fbf22a7fdda5a65150c817257cefc89ccd562286ede59d01e4a970e74847"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccc825f3b87b0bfe0e309e217cac7f8a10c2d9a5e6bfb103c47818ace888eeef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e8a8e363356cbe92fb51fe20f0a2421ad1bd68109152e6d249adfe274b42008"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dbe60466f3be0d379c5a049637831e97dcdeebe0b88c4ef7dbbd5be57ef8492"
    sha256 cellar: :any_skip_relocation, ventura:       "ee3e1ba9b675a289aa00161021d983c400a48a2295844a23be993044697afe59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e34b61261e53f5e829b005578523736b7849f33e5de0d3e6c0fbcbc3b9d8146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a76d31e93d7bd5557503096ba4e09c2add33e4ce688b98fad157956d88c0264"
  end

  depends_on "rust" => :build

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
