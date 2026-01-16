class Opkssh < Formula
  desc "Enables SSH to be used with OpenID Connect"
  homepage "https://eprint.iacr.org/2023/296"
  url "https://github.com/openpubkey/opkssh/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "120b2fafeffb8043c39d8b6e0f799a5b4c1e46a6b512307a1f7f8138d2280044"
  license "Apache-2.0"
  head "https://github.com/openpubkey/opkssh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f44f006b584643ae30b1c6ed2f1fd8252c0aecd1ab77c3606a891f56b62c8d39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f44f006b584643ae30b1c6ed2f1fd8252c0aecd1ab77c3606a891f56b62c8d39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f44f006b584643ae30b1c6ed2f1fd8252c0aecd1ab77c3606a891f56b62c8d39"
    sha256 cellar: :any_skip_relocation, sonoma:        "6170ce79392f48407af9785d880bb4829d38a97d2eed72ccd2a5f595d4de7c41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8664694a6f31b0c4a633105133b10ca86e51d06d70a8bb58faae7c4f6ec54d8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68689bc8ea2e223a5b49f5ccc0a74b0c34e7ea84d719f2f8d71f6349590858c5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opkssh --version")

    output = shell_output("#{bin}/opkssh add brew brew brew 2>&1", 1)
    assert_match "Failed to add to policy", output
  end
end
