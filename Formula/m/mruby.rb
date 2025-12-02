class Mruby < Formula
  desc "Lightweight implementation of the Ruby language"
  homepage "https://mruby.org/"
  url "https://github.com/mruby/mruby/archive/refs/tags/3.4.0.tar.gz"
  sha256 "183711c7a26d932b5342e64860d16953f1cc6518d07b2c30a02937fb362563f8"
  license "MIT"
  head "https://github.com/mruby/mruby.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b02685c5cee6b7c01b11864e751fcfdc66112bdecd861e978b3aefc0e888270f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e76e20320c6a2d04d0af8785e59a94aa7e7d992a5db9a50ffbb34cb068a9b44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d711085007c9d6fbc59688e73419eab05b717ebf53fdc1a42f870453d2e4b3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf53080c3b6edbf118092341d45846ae988fddcc6fc2cd7f24e779791e4fac2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e7d861057336fa23be40003127441e00bfb534586bc8e7baca92366d92746a2"
    sha256 cellar: :any_skip_relocation, ventura:       "9077c5d17dc2af732e8ef342a2ec492a16ed52277d7e17c2c9dfbf05d3da20c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf4078077027b1b33897a8305b00e1f2e766b005d856054b0a92b5842677f75b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87a0bfa8d4eeb79c615799174ba0be1e3fcd87deabc6d92267d1e708b951759a"
  end

  depends_on "bison" => :build
  uses_from_macos "ruby" => :build

  on_linux do
    depends_on "readline"
  end

  def install
    cp "build_config/default.rb", buildpath/"homebrew.rb"
    inreplace buildpath/"homebrew.rb",
      "conf.gembox 'default'",
      "conf.gembox 'full-core'"
    ENV["MRUBY_CONFIG"] = buildpath/"homebrew.rb"

    system "make"

    cd "build/host/" do
      lib.install Dir["lib/*.a"]
      prefix.install %w[bin mrbgems mrblib]
    end

    prefix.install "include"
  end

  test do
    system bin/"mruby", "-e", "true"
  end
end
