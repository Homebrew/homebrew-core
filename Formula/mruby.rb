class Mruby < Formula
  desc "Lightweight implementation of the Ruby language"
  homepage "https://mruby.org/"
  url "https://github.com/mruby/mruby/archive/1.4.0.tar.gz"
  sha256 "2c4a318dbb05ec745c6c4d90b810e80385901fbeb1e7f8ca3e499f5935a82430"

  head "https://github.com/mruby/mruby.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "87512993c1c274958500aaf45551572ea4897e081eefbccd9da34603e515f07f" => :high_sierra
    sha256 "2389720557c8a6421882561d096dfd84317f47c628b03852d86a34b2afb61aec" => :sierra
    sha256 "d9a8487acd5544562cfea50da211f5268f86630ed5d197ab1c9bab68b453ca9c" => :el_capitan
    sha256 "77e4dc3179a3e0f86c35fdf3aad37ff57c31cf9410f776cc953d9cfe797186a7" => :yosemite
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
