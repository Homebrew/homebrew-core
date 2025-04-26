class Katana < Formula
  desc "Crawling and spidering framework"
  homepage "https://github.com/projectdiscovery/katana"
  url "https://github.com/projectdiscovery/katana/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "94d72b9132b536b1125f51c6ee4ddf6b11bf55013a88172fe0fed979799410fc"
  license "MIT"
  head "https://github.com/projectdiscovery/katana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c758ca0022728b3168f6331fb5579737afc480b0b76a5cf894a58bcc5f7b037"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baa7d2200c443194fff7293766f5b7835a2ebc866d2dff2cfabd0d1ba82198d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0cbaf79f1f6899140543daed881e22daa43e592efb51d24ac240add06c82e087"
    sha256 cellar: :any_skip_relocation, sonoma:        "f41e84b88cfda58a0f8a6f5e4308e877b9849a532c2e8a81915e698908c58558"
    sha256 cellar: :any_skip_relocation, ventura:       "a57ed8ac69c5a8c7dd6d43c24e4b5e03c1dd8ef8fd79d65dfbc0b1337abcea0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9f1cbff466397ee43e7d860cbb37ab798fcb3d08b4960a0f96f2811f34cc8ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "648813a8db57086ba07fe0957d72b33411e5e48d8169c44933737346a729683c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/katana"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/katana -version 2>&1")
    assert_match "Started standard crawling", shell_output("#{bin}/katana -u 127.0.0.1 2>&1")
  end
end
