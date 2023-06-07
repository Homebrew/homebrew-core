class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.8.3.tar.gz"
  sha256 "2b8e8b40ef490663239f3a24f9383fd5b832530e96513d58755b688b507d876e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "972128acffa16c8a965086e80ad4b26e287bc9cd9a98fd493f87d203eac0e148"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcfe84da0b9ee7d01af51de754542c1e5bfacb4339caf3426b26e6addd5b9322"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "349e706fd7754a51ccf3496cbfc9cf96a8910811d4aff1a22f2edf03059b8864"
    sha256 cellar: :any_skip_relocation, ventura:        "4ebdff903e2ab3f51c4888d095b95041a43689c39ac8cafde77a77b7046eab03"
    sha256 cellar: :any_skip_relocation, monterey:       "5495bdd64c48dffb26d4b0cb26642ffc39fe852180696a55eab8264e4a37fa49"
    sha256 cellar: :any_skip_relocation, big_sur:        "32f7a9ead32e427bb95ae256c7725b4b85ae429c19304ccd29cd169fd810079e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59b62c16737ea8f6d2159ce0cfd274c2a4d0c70474779a44c2ee47851b6d08a2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
