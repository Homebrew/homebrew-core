class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.4.8.tar.gz"
  sha256 "3f2038849b45c5f7eba70532ec0a62c69ec54d029e2984178a1bdd995b531807"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "07202d83463c5639a2a4ce7e5db36be0f624d796d0a041c73bee306674091f11" => :catalina
    sha256 "d2b4191a02fa44db2b24b0d663104ef03201aa1838ce6dadcf29b1527949024f" => :mojave
    sha256 "a64457ba73c4fe413e09c4489c47dc7f3bf50da44142859520308936072dfbc0" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X github.com/miguelmota/cointop/cointop.version=#{version}"
  end

  test do
    system bin/"cointop", "test"
  end
end
