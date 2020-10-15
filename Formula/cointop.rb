class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/v1.5.4.tar.gz"
  sha256 "9d6d11e71c3c754a654b191a6813a41427c717966999ce335f0f155358a2292b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b3ab6e0ce9af52ddd7c07c47b1c97067fcf1cdefb2663b21fe10d0db20bb467" => :catalina
    sha256 "bbaf1d1da14a998b7f786b5135e09b2178b790dcf4efacb77c72f0c0c29aee2f" => :mojave
    sha256 "6b8901459eebd705f512c122812815afed289265e3ae406d1e8054aac4261e70" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X github.com/miguelmota/cointop/cointop.version=#{version}"
  end

  test do
    system bin/"cointop", "test"
  end
end
