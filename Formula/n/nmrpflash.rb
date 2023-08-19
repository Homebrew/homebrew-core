class Nmrpflash < Formula
  desc "Netgear Unbrick Utility"
  homepage "https://github.com/jclehner/nmrpflash"
  url "https://github.com/jclehner/nmrpflash/archive/refs/tags/v0.9.20.tar.gz"
  sha256 "4aa17a84735f04e91b5e90e9a61e8c48033a5689bf45594ea1eeff715f0acd48"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da2ba840d084cfbe19cf91fded8435490e2d4a3edd67408e2b83834e7c6b3c31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87f57cd2988fdd5743467a10929845eed62dc0f1e894286e6adb8ac77303e110"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87a4d3fcf68e8a1087b3f28fbb85ea92c676d652e0b057f70da63b7709fa9b4c"
    sha256 cellar: :any_skip_relocation, ventura:        "b8638d2e3f4f1b7698ea413a323dca2ac7af46c010126b058e6228718a565cab"
    sha256 cellar: :any_skip_relocation, monterey:       "ad1413001fcfb694c5d4c1f2cc47509fd39c9990c6b8c2b51226c712879f32cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "d818d50c7ebcbb07a4e3fbca5100849fa8eaa4f64ea2b98d18a3f35977f0891c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dceab7348d37e77a710ea02f9e53c4f741c692122ff8e4ba9deac429d141501b"
  end

  uses_from_macos "libpcap"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libnl"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "VERSION=#{version}"
  end

  test do
    system bin/"nmrpflash", "-L"
  end
end
