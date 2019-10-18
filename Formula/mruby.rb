class Mruby < Formula
  desc "Lightweight implementation of the Ruby language"
  homepage "https://mruby.org/"
  url "https://github.com/mruby/mruby/archive/2.0.1.tar.gz"
  sha256 "fe0c50a25b4dc7692fd7f6a7dfc1d58ba73f53fedda5762845b853692cfac810"
  head "https://github.com/mruby/mruby.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d11cb38cf918e44362f4369f1c3f46414059fc2caf4703b3d32f35d34fa44606" => :catalina
    sha256 "3279a9fe511530c4fe0a56323efcbfd555d2fa981204a0d1595f0365f56cdd59" => :mojave
    sha256 "3e808c9c9a25a98a20a8af26a369bf688db7c9a635e3ae52836e2eda0e42b442" => :high_sierra
    sha256 "5244571e026eefa0158a177b1b6e1c42c91760cb8e3b5ef449277660b31aaec6" => :sierra
  end

  depends_on "bison" => :build

  def install
    system "make"

    cd "build/host/" do
      lib.install Dir["lib/*.a"]
      prefix.install %w[bin mrbgems mrblib]
    end

    prefix.install "include"
  end

  test do
    system "#{bin}/mruby", "-e", "true"
  end
end
