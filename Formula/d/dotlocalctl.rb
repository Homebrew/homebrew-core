class Dotlocalctl < Formula
  desc "Backend CLI for DotLocal"
  homepage "https://degreat.co.uk/dotlocal/cli"
  url "https://degreat.co.uk/packages/dotlocalctl-0.0.2.tar.gz"
  sha256 "fbffedcac5440dd4434ab0eac3e9920203196781eab589d872dfe23f880b28f5"
  license "MIT"

  depends_on "rust" => :build
  depends_on "caddy"

  def install
    system "cargo", "install", *std_cargo_args
  end

  def post_install
    system "dotlocalctl", "configure"
  end

  test do
    system "#{bin}/dotlocalctl", "--version"
  end
end
