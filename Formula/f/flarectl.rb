class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/v0/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.116.0.tar.gz"
  sha256 "d594cdf6730046eae27240324d32a8f43a2affa7f61706459ae912fa9f4d085b"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "v0"

  livecheck do
    url :stable
    # track v0.x releases
    regex(/^v?(0(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ad5f090588698e86d1167e4229eebe2a108d4e2577139d567bb01e45977d80f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ad5f090588698e86d1167e4229eebe2a108d4e2577139d567bb01e45977d80f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ad5f090588698e86d1167e4229eebe2a108d4e2577139d567bb01e45977d80f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ad5f090588698e86d1167e4229eebe2a108d4e2577139d567bb01e45977d80f"
    sha256 cellar: :any_skip_relocation, sonoma:        "23fddbdb9310f7d645c7f2958819d39b8f91efeed247d2c4555852bce7a4245b"
    sha256 cellar: :any_skip_relocation, ventura:       "23fddbdb9310f7d645c7f2958819d39b8f91efeed247d2c4555852bce7a4245b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "396cd2459e80c6ed540d39bb72542acfdda3c603bdecf5b02df222224ec8a313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43110a60ec6ce3bbaf46360197b2dc7eb17e7cb321eb8e630760c22b3e79706a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
