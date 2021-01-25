class Asroute < Formula
  desc "CLI to interpret traceroute -a output to show AS names traversed"
  homepage "https://github.com/stevenpack/asroute"
  url "https://github.com/stevenpack/asroute/archive/v0.1.0.tar.gz"
  sha256 "dfbf910966cdfacf18ba200b83791628ebd1b5fa89fdfa69b989e0cb05b3ca37"
  license "MIT"
  head "https://github.com/stevenpack/asroute.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dded44d666d600e065f0a49e0c26eaa56597f1235ff937703c8dff298f665453" => :big_sur
    sha256 "816be1190f677bb1ba13d1b1fd92a0ca7550341810310b59be200227936afc9c" => :arm64_big_sur
    sha256 "873d80ef73a84598637218e467a0887477e113a9f26d8dd1f1a4b6a4571b11b8" => :catalina
    sha256 "6dbd83956cb0d73b74fd8fa6706206c7d9701eeb6a44f0e6eebcaebd9b96fbc2" => :mojave
    sha256 "77fd60fff4aa4abf7e9fd7bb7e14961b3eaab1aae0f074a318d874ecd869d32b" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install "target/release/asroute"
  end

  test do
    system "echo '[AS13335]' | asroute"
  end
end
