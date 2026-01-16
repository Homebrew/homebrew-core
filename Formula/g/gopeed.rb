class Gopeed < Formula
  desc "Modern download manager that supports all platform"
  homepage "https://gopeed.com"
  url "https://github.com/GopeedLab/gopeed/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "06c8214fca54f54f94dd66df1a653735b75743e0a1af2c2958a352ad071fc767"
  license "GPL-3.0-or-later"
  head "https://github.com/GopeedLab/gopeed.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52d7ae6c778c6b4da79bf6575976dbb09fe10b58865516e87a6bf9b19761a013"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03211790225d95d5767f4a7a2ce06193a6382b2c686cc0e34d04a080dde1754e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69e669d597f6ed85aee86cf11f93d482136e23282abfaebb468f94e96e328b59"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd7290a5623e5a6b6af0866df2f0c702947d3b802343254e1d43e2bd282d0a53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1f444eb2c41b319892d4a4a243243b8f9ff731d265cc2f943606b231441de05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cf0d9c0d2ebfa1037bb126cdc40aec9eca407b2ecce636cfc0430eab62d8791"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gopeed"
  end

  test do
    output = shell_output("#{bin}/gopeed https://example.com/")
    assert_match "saving path: #{testpath}", output
    assert_match "Example Domain", (testpath/"example.com").read
  end
end
