# typed: false
# frozen_string_literal: true

# :-)
class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust. 🦀"
  homepage "https://github.com/epi052/feroxbuster"
  url "https://github.com/epi052/feroxbuster/releases/download/v1.1.0/x86_64-macos-feroxbuster.tar.gz"
  sha256 "cebccff81d0c949918e112032a5daeafaec09b79f855e1cd3df71069359c782d"
  license "MIT"

  def install
    bin.install "feroxbuster"
  end

  test do
    assert true
  end
end
