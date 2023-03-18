class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/swsnr/mdcat"
  url "https://github.com/swsnr/mdcat/archive/refs/tags/mdcat-1.1.1.tar.gz"
  sha256 "2757e1a26a7843c673c2aecd1866c1714af74883ebb0c4195384a62b6a7627ec"
  license "MPL-2.0"
  head "https://github.com/swsnr/mdcat.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bee9efe9ba74ea48cf36b00dc39d6e7c396e6108e4a7c67ddb3a1d777dd60e85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90088aff36ec567afc4413cdef6b321866970ac167f724b6a0434156f19b67d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ed3dacc98600479e723d3e9d9a0754a0885fd104029c21e849ecce42b0553a4"
    sha256 cellar: :any_skip_relocation, ventura:        "2041884d1b2356dcc72dfe7f8165a2bc71d9516bcef3e1975179c850e357ce95"
    sha256 cellar: :any_skip_relocation, monterey:       "222c07357890923cdf3bf7905c7d23de2f19fd0e1c7383a305a942933f645a81"
    sha256 cellar: :any_skip_relocation, big_sur:        "fad1d1bb9b6f4cf0d1071baf7d56071465d715c59d2baa8a7b7942acd6785ddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c86e742fd8087deb1f026f08b07dea11108bf19a121b6e5a59b830ec73856963"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
