class Mruby < Formula
  desc "Lightweight implementation of the Ruby language"
  homepage "https://mruby.org/"
  url "https://github.com/mruby/mruby/archive/2.1.1.tar.gz"
  sha256 "bb27397ee9cb7e0ddf4ff51caf5b0a193d636b7a3c52399684c8c383b41c362a"
  license "MIT"
  head "https://github.com/mruby/mruby.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1266b351ab448a0d30f7a6bea0bf5e395b3ee40af5eb134c7a6c6bad3c958457" => :catalina
    sha256 "ec046526f5cdc28b079efe9d514702a8b98a61f6388fb4479f0e0666559e5997" => :mojave
    sha256 "1b924c188725c14fd0958f5c5314f723cdfca53fc9eb59b266d7b1678e43552c" => :high_sierra
  end

  depends_on "bison" => :build

  uses_from_macos "ruby"

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
