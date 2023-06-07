class Jless < Formula
  desc "Command-line pager for JSON data"
  homepage "https://jless.io/"
  url "https://github.com/PaulJuliusMartinez/jless/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "3f1168c9b2432f7f4fa9dd3c31b55e371ef9d6f822dc98a8cdce5318a112bf2d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc206f32743e131b66991b39f15fc2db5cc9ac4fb8440d38ef351dcf3617ea24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9702468099f0396e88ca93673840aba8a9771d1628b0e4a94bd5dbdb7869d65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c86789cf44ab4c397eeabcc263a4c7efef3ee0a8f5cc9383406131bdc7f946c"
    sha256 cellar: :any_skip_relocation, ventura:        "322be887e2b2f9e53633210416936269ad61d4e0932f6658cd6654e5fbb6e3c2"
    sha256 cellar: :any_skip_relocation, monterey:       "837c1aec0a87ea6098bcfa6bc3fc0e858c70f2ac1cd6c65a2f21f141a711b4d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e2bf888a308287819afc9c07cd82f0019d814ad9010509fc85d2eebae72a385"
    sha256 cellar: :any_skip_relocation, catalina:       "d3d6dab05c0270e22f00ed0018674d8fc4320e3fcb96bd87dd2b11377b461903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c51148db8c9832eb370af8ea635aca9d2d0c4d0095c374710baaa41a7cb70045"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "python@3.11" => :build # for xcb < 0.10.0
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write('{"hello": "world"}')
    res, process = Open3.capture2("#{bin}/jless example.json")
    assert_equal("world", JSON.parse(res)["hello"])
    assert_equal(process.exitstatus, 0)
  end
end
