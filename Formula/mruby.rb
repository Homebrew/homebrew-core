class Mruby < Formula
  desc "Lightweight implementation of the Ruby language"
  homepage "https://mruby.org/"
  url "https://github.com/mruby/mruby/archive/2.0.0.tar.gz"
  sha256 "fa495898d51130c69480a13e90df5dc18cb1a9d9a31836268a895989d902048f"
  head "https://github.com/mruby/mruby.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a1dcc1710f107e993a38b3262c7235f71cf12a80ca7a5dd0cd3c579430b7a20" => :mojave
    sha256 "235c0c374c2dce600e00ac2b95fa7575a541a725f0c55e06bd3f7577b5309ed8" => :high_sierra
    sha256 "5d41f43e7524997f9bcba2ca181dc838e47543941fc44ec686460ef7c675754c" => :sierra
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
