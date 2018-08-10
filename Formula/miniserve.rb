class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.1.5.tar.gz"
  sha256 "b435471cd08f3dbe080e26a0b6937c824502a87659948f49b5d2e54f07de64e0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    # miniserve has no options that do not immediately start listening on ports
    # that may already be in use.
    system "#{bin}/miniserve", "-V"
  end
end
