class Csprecon < Formula
  desc "Discover new target domains using Content Security Policy"
  homepage "https://github.com/edoardottt/csprecon"
  url "https://github.com/edoardottt/csprecon/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "a3d9ed64cee648df81b410ea4a3e42afc9ca13fb77f7717163b756665f4b1233"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bb3a951f8095ae1544dd71d54fb045eb0d1109c455fb36f950dcba0b50748a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2687c0535a5f691d5901e15c83ce9b57bd72031d644bf69a2aacffcbdb2fe5c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86b457675bb44c86452e13f34eaa68814261851217ffd9941aeecff973e56bf2"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2c5788908d476e893f4dcb1f965d03213003a1db84fa3025e7977c8d5f7f19c"
    sha256 cellar: :any_skip_relocation, ventura:        "85f66e17ee062b9f1422145b722989c4923d15af9a3af96016e359023b16d34e"
    sha256 cellar: :any_skip_relocation, monterey:       "15d0097d533bbcd6d23e8c708239b897c1d03f7d0649b811e0d2f5eeb8b95519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee90531f66595d94ea39bb6e6234caf123e168cb063a44fe96294ab47bd2bc21"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/csprecon"
  end

  test do
    output = shell_output("#{bin}/csprecon -u https://brew.sh")
    assert_match "avatars.githubusercontent.com", output
  end
end
