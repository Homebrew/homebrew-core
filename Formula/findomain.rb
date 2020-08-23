class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Edu4rdSHL/findomain"
  url "https://github.com/Edu4rdSHL/findomain/archive/2.1.1.tar.gz"
  sha256 "ff5f4cdf4b7eaf1401041916cb30a887fa76149711430e97c296a481c04d7f64"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f95c04f667d692cd8d53901748fde2d68eb5d8b20ba0f48530f951b8c4431b6" => :catalina
    sha256 "b50c42a2a094a014a434894139ca08aadf854e3b0539669c83198100d12de3f9" => :mojave
    sha256 "dad27a046c9642474c9fab22d658abebd0e660ce9ba1130633db0dd7b54e2969" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
