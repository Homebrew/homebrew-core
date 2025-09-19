class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://github.com/guyfedwards/nom/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "6097e96980e7de401e699f2608635e6bb57c09884f2d04d9dadd57a6374f330b"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f6fbfb521a301a3310d03b5ba292b8d1f50faaef1ed555e15091c3c65473756"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d519f1348258605c0a7e3226ffd28036e58df7471dbd12a04e080dfc470fe9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40b4533c7646fff181cac42ead095b77c885e6dead03c3507b09da20b989bef3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ecac47f089863eca5af5043b3cfbd6db8f5a5234e20888ff64a0a426b3f26a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "356d2b0699f6d9f1945379492e70ca91c4a68673a972a7dcb7cfe87e285ef0a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15fdfb3b8bff3b29e80e54d1e333915e940d300da54589adff2869620572d019"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/nom"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nom version")

    assert_match "configpath", shell_output("#{bin}/nom config")
  end
end
