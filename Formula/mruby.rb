class Mruby < Formula
  desc "Lightweight implementation of the Ruby language"
  homepage "https://mruby.org/"
  url "https://github.com/mruby/mruby/archive/2.0.0.tar.gz"
  sha256 "fa495898d51130c69480a13e90df5dc18cb1a9d9a31836268a895989d902048f"
  head "https://github.com/mruby/mruby.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "baabae8e910bca1fe373a992a8fa9f1442f727fac254ce64fd38c6d64cdd21b2" => :mojave
    sha256 "a2d57a7ffeda0a31012372ef4d039cfbd0ad17e53d7c2fd80157f5cee5e29e37" => :high_sierra
    sha256 "54d788bb33206662ed61e08904c1b7259f3f4d0f30794688d4491fe2b065ebf0" => :sierra
    sha256 "aefc7ac4b27caaf0ebc7919eeb1d06b0bfa2d18ee9a26d9dee99ae9e4f22d788" => :el_capitan
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
