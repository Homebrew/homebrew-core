class Bcal < Formula
  desc "Storage conversion and expression calculator"
  homepage "https://github.com/jarun/bcal"
  url "https://github.com/jarun/bcal/archive/refs/tags/v2.6.tar.gz"
  sha256 "bac318405221f2f88d374683549338515b070ca7491497eda2ac9c17bcbb0458"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "03eadbc7dd38eaf08b6f41622b64f3690f1889da8c6bfff3e7d8af9cfc942f05"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "23a90d61c6c0649143a059f62a3b28ff6029ee96a15f2583810348138997f4e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a015f9c45c2119bcf4fe36d2de093ef2174845c6773a995aba1d2101d3c89c8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "12041176b8f15176a5e92c2d4620e8820f14a6320c95e3f17a9b9d505ad6d9c0"
    sha256 cellar: :any,                 arm64_linux:       "8ef7c291f3a2dbf769357ad24b3f5e76257e36c17375112a81eae7520da28227"
    sha256 cellar: :any,                 x86_64_linux:      "cd3f6614547d1bbd513c15a5d822150068de24e6cd61e70061064b85cb67baee"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "9333353817", shell_output("#{bin}/bcal '56 gb / 6 + 4kib * 5 + 4 B'")
  end
end
