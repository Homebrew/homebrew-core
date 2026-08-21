class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://github.com/nift-dev/nift/archive/refs/tags/v4.0.5.tar.gz"
  sha256 "1c0124ae6e6feda08b691b9093838432c48b4c0df4b1f36bc009fca6ebc14c18"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bef68af1ee423447645a31502fab97e2221582955a1aa197a76179aac2f85b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f02ed658c264c88923acac87ac6a704b25524c272060df13a162a126c542b57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a518855b5a7c929a586f9b3797612129371a398686bdfc938727744320e0dd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e026344a98244e37514d25bf9f1036ac0c39eb235d206b25ec03f25c2ed79bd8"
    sha256 cellar: :any,                 arm64_linux:   "c9a91da6bf81d7cf90a948b7c89378319bc579fee0e38bba572f29753811b1f5"
    sha256 cellar: :any,                 x86_64_linux:  "b989396b6ed82f656463a93968565d5df492233921fc929380f305c58f7e2ad6"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"nift", "init", "--ext=.html"
    assert_path_exists testpath/"public/index.html"
  end
end
