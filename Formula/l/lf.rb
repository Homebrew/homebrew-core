class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r31.tar.gz"
  sha256 "ed47fc22c58cf4f4e4116a58c500bdb9f9ccc0b89f87be09f321e8d1431226ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "968de8be39eaafaef7e51a2965f030e53dd6eca837b153845ebfa1c09787ddaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44b417555760e39467a5f936529ad18f37d141bc2a32c7584262b833878252ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7acab79bef9282e03fcd5bd1c35a0f8d65c9c6c7b2f454294f0ae6aa0e721d2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cfd9990611815ea11e9770c70511ec6ced4e01c120d2d826f01efed1f42497d"
    sha256 cellar: :any_skip_relocation, sonoma:         "14fa673efb46dd363383e54810abddb914871e964b9c86ac583c10f1d8d29102"
    sha256 cellar: :any_skip_relocation, ventura:        "c8c447b5f36fc58b75f6bb7dbd6193bfe43dc5883c160d400a29490d062eff8c"
    sha256 cellar: :any_skip_relocation, monterey:       "023881834960674e6769e865767dabaaf5c6e66f69b429ba20ed996cc9f37224"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7d7684867950aea4e5894a261d6e36339e27f703ad26a78a00c61f69a096299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad09e5718421ca4d2dde687fc364bf9c954c42a17084a4c99b1ead10140a3f14"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.gVersion=#{version}")
    man1.install "lf.1"
    zsh_completion.install "etc/lf.zsh" => "_lf"
    fish_completion.install "etc/lf.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
