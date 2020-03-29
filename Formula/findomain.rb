class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Edu4rdSHL/findomain"
  url "https://github.com/Edu4rdSHL/findomain/archive/1.4.5.tar.gz"
  sha256 "f19f9cf8508502f5b054ca7eff88eca84abf5f7903e6e3abb8b7c9feaf721d57"

  bottle do
    cellar :any_skip_relocation
    sha256 "21dd3bcf4f6cc2c4079ce1d810e09e85274a2d56767bd5fe4f4c6e343a9e29f4" => :catalina
    sha256 "977329cf0a52c16d75694d21d742f23e194ccd1da84314522132644b2a6b56ff" => :mojave
    sha256 "b6c70546d00fa5532eb6fbc659939064c8d0d0505995e499fa88b66bdb1535e9" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
