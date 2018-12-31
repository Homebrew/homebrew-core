class Deno < Formula
  desc      "Secure TypeScript runtime on V8"
  homepage  "https://github.com/denoland/deno/"
  url       "https://github.com/denoland/deno/releases/download/v0.2.4/deno_osx_x64.gz"
  version   "0.2.4"
  sha256    "191359c3e22411f42038a67288d620966ffcefb1e868e34bdec8db3f35e02b3f"

  bottle :unneeded

  def install
    bin.install "deno"
  end

  test do
    system "#{bin}/deno", "--version"
  end
end
