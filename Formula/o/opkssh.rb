class Opkssh < Formula
  desc "Enables SSH to be used with OpenID Connect"
  homepage "https://eprint.iacr.org/2023/296"
  url "https://github.com/openpubkey/opkssh/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "1c53a965d58b7c5c33abfbaa0219c357aa5f1d518ba0a63b44ea16b0aafdd17b"
  license "Apache-2.0"
  head "https://github.com/openpubkey/opkssh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0dc9c31cf48d286d9f60e846dc8a745f9e3375b877079742974edd2fc6ab213"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0dc9c31cf48d286d9f60e846dc8a745f9e3375b877079742974edd2fc6ab213"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0dc9c31cf48d286d9f60e846dc8a745f9e3375b877079742974edd2fc6ab213"
    sha256 cellar: :any_skip_relocation, sonoma:        "50cadf1429164febdea4922d26c63e46f7e5371566801a356c8b3205030d2ce8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddd04eead955cc8db01be5176f6a4b57f153d6b4ebe01439c3ee2b69d959b71a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37357dddb020cdaa317f1f00192799756df84ea176097d836c2222148b569f05"
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
