class Meli < Formula
  desc "Terminal e-mail client and e-mail client library"
  homepage "https://meli-email.org/"
  url "https://git.meli-email.org/meli/meli/archive/v0.8.13.tar.gz"
  sha256 "b1414defb7973a96ed0510b5cb888aa8671fe4f3f832c5baa0c79dcd61ba2edf"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://git.meli-email.org/meli/meli.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5784a603ab62624ab0f093ccc3f407c5390841ea780dedd72e3cbbcb87943259"
    sha256 cellar: :any,                 arm64_sequoia: "217a27feab49a34548a1ba893647f7b9a899513ba0b63897475e28d212bf3b6a"
    sha256 cellar: :any,                 arm64_sonoma:  "b66fa0a475e1b0bfb810e3d579eb1b129c1475afb9443e254f076e71342203af"
    sha256 cellar: :any,                 sonoma:        "a1c21bf8bfe2800cd52c7f3d23dc76871b99635578defaed3db7f43064f88d4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6aab574892fb5e9ef1b2654b840e94c364f4981086e5c7ba84ed4b477438700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df9bb9511f829b1e9773a7d20f8998945daad30be756da93ebc6ae0306f0b6da"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "meli")

    man1.install "meli/docs/meli.1"
    man5.install Dir["meli/docs/*.5"]
    man7.install "meli/docs/meli.7"
  end

  test do
    output = shell_output("#{bin}/meli print-config-path")
    assert_match (testpath/".config/meli/config.toml").to_s, output

    assert_match version.to_s, shell_output("#{bin}/meli --version")
  end
end
