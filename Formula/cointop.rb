class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/v1.5.5.tar.gz"
  sha256 "ec0a0765d768d5f019cf47b1173db84881b5540088cc0e5570fb8140355d3199"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5816d00059223189e26efd3db01da8ed68bf6487ee7f6a2c8e7d234e8a20562" => :big_sur
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
