class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.10.10.tar.gz"
  sha256 "d7cd322301b2f273474950a7bcae4180681825ba357c900b50aae5dadc44cc4c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9bbfd9db7b2e74ca5aa226d2ac69363b08e3032fb03aa0c06a30f8dec641488"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "248e21bfb8ae0b088fe75777d17ba1cc495d220b57922001cdfcf30ad293e045"
    sha256 cellar: :any_skip_relocation, monterey:       "f4e45409562f18134076e4d766b7894ca6aa7e9d150c38ab928df270d7d9a71c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e605f009b1021edc71fbf1277b815c209b4d85702f0edf061cdceb76d3295026"
    sha256 cellar: :any_skip_relocation, catalina:       "a4c77cf102e5cefb3607593351e838dab704b94118f4b6d059165bbeb10ce795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdd13e5099aa7464799727452f7b7cb98d555c1ed3674bd4e9f2bcf3c6657b42"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "swagger", shell_output("#{bin}/observer_ward -t https://httpbin.org")
  end
end
