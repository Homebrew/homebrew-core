class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/0.20.0.tar.gz"
  sha256 "4bbf05be32439049edd50bd1e4d5a2a95b0be8d36782e4100732f0cc9f19ba12"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f496b2e21cc348358f32175ff44c0f1e88ba3c2c8b9a07c083fba78b271506f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a81e3e8c8b0639383dee9945a0a6f40e64c2c7d4d6706168ad13dd069007207"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "430ee18eb71232cfb3ded1fb80ae051d59c4d193a65330cac387ec3331017500"
    sha256 cellar: :any_skip_relocation, ventura:        "3daf225eb58ef12c781439c9101d3b2784b8a3dc330150fafaa86b9529a9a655"
    sha256 cellar: :any_skip_relocation, monterey:       "b7b38e5e3f682261a03ca1df79d71f9c48dfe9d8350c436f07a9c8288c5f0d87"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1256a409795dd2f5e6c021c2038349c3a2ba38c6c0b54dfa0288fd10f23e3f4"
    sha256 cellar: :any_skip_relocation, catalina:       "27ed0f76c29c31c7427853592e7b86d8f291414c356ac714f053b606bf495234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "053c72d686f7e10f7f8457329715b727fefad9ce4952e41a8d031599eb1f8b22"
  end

  depends_on "rust" => :build

  # patch build
  # upstream issue, https://github.com/imsnif/bandwhich/issues/258
  # upstream PR, https://github.com/imsnif/bandwhich/pull/259
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/96bfb409db46dfe53b76da7682ddcf650af45921/bandwhich/0.20.0.patch"
    sha256 "ea446f63c9e766ab9c987c83f1ca5f6759175df4e2b3e377604fd87a2b0b26de"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/bandwhich --interface bandwhich", 2
    assert_match output, "Error: Cannot find interface bandwhich"
  end
end
