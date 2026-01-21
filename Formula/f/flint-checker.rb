class FlintChecker < Formula
  desc "Check your project for common sources of contributor friction"
  homepage "https://github.com/pengwynn/flint"
  url "https://github.com/pengwynn/flint/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "ec865ec5cad191c7fc9c7c6d5007754372696a708825627383913367f3ef8b7f"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "dcbc6af7ead098630fa98be1dddcad97432d65ccfbed01d7fb98120cadab7257"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1f101ecd31a4b9eca93ee5d2147e9179ce0e9a6f90919b00c7151859ec66fc14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed6f5260d4529072857dd5e87ae92324dbceda9c2de26ad7264900beab01d3be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5056c257e0cc996faf15565e602c5e5a8fc7655a864f1bbf4fb655bb3599908"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7a3874abb22d4ba7d1641f6fe8f8bff8262150f5031c335430b20156062165d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "beaa467d1e1290795f33302eee355ab5e32216602a82cbe8083d82d163e9aa50"
    sha256 cellar: :any_skip_relocation, sonoma:         "fff4cb08e2ebcef9f5bbb73a4ae8afdcf01b0349841d59864399c4c627ca64bb"
    sha256 cellar: :any_skip_relocation, ventura:        "7560d772fafc17dd5037aa271009e8e18645cc6ad2afb57df36316cd042a1195"
    sha256 cellar: :any_skip_relocation, monterey:       "a173b1a8329d81cc39c220f535e84c940a3f4e3e8b7505d590fb7411571a6710"
    sha256 cellar: :any_skip_relocation, big_sur:        "167b3ab36ec6ddb5b07b4524d090596b18fd9267cf9da5161e78d11b1f988397"
    sha256 cellar: :any_skip_relocation, catalina:       "48211955f96e66b5254338d9f6ba56e6e35f6680fb0379190f5b4a3d8f6fe6f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "70ef7665f0a159f49400f121b6cedcf3b76f639dc517a422a0332d839fc1a8fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01e5b0c9b671bceb2c20ffac4f21f6bda8004d761746260ad82d6c16b13258ea"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/pengwynn").mkpath
    ln_sf buildpath, buildpath/"src/github.com/pengwynn/flint"
    system "go", "build", *std_go_args(output: bin/"flint")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flint --version")

    shell_output("#{bin}/flint", 2)
    (testpath/"README.md").write("# Readme")
    (testpath/"CONTRIBUTING.md").write("# Contributing Guidelines")
    (testpath/"LICENSE").write("License")
    (testpath/"CHANGELOG").write("changelog")
    (testpath/"CODE_OF_CONDUCT").write("code of conduct")
    (testpath/"script").mkpath
    (testpath/"script/bootstrap").write("Bootstrap Script")
    (testpath/"script/test").write("Test Script")
    shell_output("#{bin}/flint")
  end
end
