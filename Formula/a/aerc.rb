class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.16.0.tar.gz"
  sha256 "b81b4f27272df2e370da377438a500c0695d29b8a4c86ff5849d6ddf3433f4db"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "f41a3ae71d83d1930196fb797c787c03a864f6bc3689f63913791c39ff8a22d6"
    sha256 arm64_ventura:  "5a0ad8d4ce862d66df0face156b007431671501189ac80155b9418afb118e2bd"
    sha256 arm64_monterey: "ca9345176d73e511d2987d0b04307f78fa770e3fd6785e7bdf927d0adcfe0426"
    sha256 sonoma:         "386f56efba97c83def72fb57e151d3948ce3c41421e61ea3193ff338e1f0eb88"
    sha256 ventura:        "623ed9bcc483fce75b8614a69a77d21f959db28ee1bb80303563fb3dea1e5361"
    sha256 monterey:       "b8bc89f19652f9527d179e90544e5064827b4df184b03da42b832b49f98c0c0e"
    sha256 x86_64_linux:   "188fe10f32bc622bd55b222466530f2823b39c2ac250d76a6fa7db06c33fa09c"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "PREFIX=#{prefix}", "VERSION=#{version}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/aerc", "-v"
  end
end
