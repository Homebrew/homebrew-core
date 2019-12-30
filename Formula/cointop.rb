class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.4.3.tar.gz"
  sha256 "842b11703e4e8c825c7d0e3d167c018f44b555d9bde467a1f57be4aba7ba8606"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cee5844824a7ecec45c07c7fe46b300c51828ebcfee30d328704b7328aba58aa" => :catalina
    sha256 "ab20b801fffdf992f5320b0cae3e682775f4dd005dcba9c9a447482a55f6c7fc" => :mojave
    sha256 "09b107a745e4122439e77715e3e28a529daad29344e0e3d8b89177340ccb01bc" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"cointop"
    prefix.install_metafiles
  end

  test do
    system bin/"cointop", "test"
  end
end
