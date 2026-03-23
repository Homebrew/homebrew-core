class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.7.2.tar.gz"
  sha256 "e2163169b18781425e87566abf21a235513cef457a4bd27c14c304cf9a872971"
  license "MIT"

  livecheck do
    url "https://entropymine.com/deark/releases/"
    regex(/href=.*?deark[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b1d89387da4b2e5c2626e39e67a38042b5ebb77c041be2fcc3e267bd59814e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ac463d89b1de8e703446ae41acc161e4b2188decceb0709fe188c11a0674bda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "029dcced69ea218ee0dcdff678387ac17d421b2debe472b40b87e5dca8dd2afe"
    sha256 cellar: :any_skip_relocation, sonoma:        "124d7842655076287bfb363bdd3cc0c7c97c7275125588ae9f44ab8a324c3262"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4caec2711f3f0f3e3d9339a4efead42bf0c10a05d4a6986c466f976a877d119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dafff439bf4b70a04558225a992ff78f4da434d4dd6b7d6ced1da488341d1e6"
  end

  def install
    system "make"
    bin.install "deark"
  end

  test do
    require "base64"

    (testpath/"test.gz").write ::Base64.decode64 <<~EOS
      H4sICKU51VoAA3Rlc3QudHh0APNIzcnJ11HwyM9NTSpKLVfkAgBuKJNJEQAAAA==
    EOS
    system bin/"deark", "test.gz"
    file = (testpath/"output.000.test.txt").readlines.first
    assert_match "Hello, Homebrew!", file
  end
end
