class AmberCmd < Formula
  desc "Amber CLI client for generating, scaffolding Amber web apps."
  homepage "https://www.ambercr.io"
  url "https://github.com/Amber-Crystal/amber_cmd/archive/v0.1.13.tar.gz"
  sha256 "2b56718bf1623dc03d25183544d9ecf2f980ac60407e6c7320d83bcb4102b99c"

  depends_on "crystal-lang"
  depends_on "openssl"

  def install
    cd buildpath do
      system "shards", "install"
      system "crystal", "build", "-o", "amber", "src/amber_cmd.cr"
      bin.install "amber"
    end
  end

  test do
    system "#{bin}/amber", "--version"
  end
end
