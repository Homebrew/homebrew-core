class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/v1.5.3.tar.gz"
  sha256 "da7c975a19b71cb0c62afd69565ce98eddbb54d3b875e277e0fefe32456b106e"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1c5866737d23bad05bcb93defac57937cfc730058aa9eeabb111312a6a5fd83" => :catalina
    sha256 "844460200a674aead4c38f5fe055a05f6b82b535aaef2344b2c246bee58d43c6" => :mojave
    sha256 "5b0f1053a6bac641791ba1c28a29dc62bd83765ba30b33e084727f57d37b6814" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X github.com/miguelmota/cointop/cointop.version=#{version}"
  end

  test do
    system bin/"cointop", "test"
  end
end
