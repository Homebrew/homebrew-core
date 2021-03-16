class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/v1.6.3.tar.gz"
  sha256 "636f3cfb5f9d748e874ede149acb6b96c7b2be8d39b73ef22abb9dd0d214358e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c7f83ffd254a7c243bb492e01a84e74acf7c28f1e79c699c44dc66f3a79e90b7"
    sha256 cellar: :any_skip_relocation, big_sur:       "879b18f3d7a683748009462c983c6c683d53a0c940a8a50c59c5f9edfb205019"
    sha256 cellar: :any_skip_relocation, catalina:      "99a20daae576755c17c9c8efcbdfb8d7f4eb4a2d0df4248c7b7891d1e7f70202"
    sha256 cellar: :any_skip_relocation, mojave:        "cf4455df03b81390c281e664b20b662efe203446656b10060e48501ead2545a6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X github.com/miguelmota/cointop/cointop.version=#{version}"
  end

  test do
    system bin/"cointop", "test"
  end
end
