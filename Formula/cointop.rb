class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.4.8.tar.gz"
  sha256 "3f2038849b45c5f7eba70532ec0a62c69ec54d029e2984178a1bdd995b531807"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0febcd7ed6ca56d2e120c5ba225a293fd564cfe43e582ee8295ddd0240ad30e" => :catalina
    sha256 "e24e0fd427f8eab96fdeb1e90349a776ababcab6346b695495b0d2cb80d52311" => :mojave
    sha256 "1374a8fa5bce92d2483138833540661538d6d1f99e2fced94d7b12ad27b9b604" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X github.com/miguelmota/cointop/cointop.version=#{version}"
  end

  test do
    system bin/"cointop", "test"
  end
end
