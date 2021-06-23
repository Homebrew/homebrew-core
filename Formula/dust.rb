class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.6.0.tar.gz"
  sha256 "4d13a2edf38ab7bfc01b700f5856c92aa3772249a203b34247c3b2c7dd8fa574"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "63975da52bf489fa48faf28948811662e212ba34bd3eec9e46326ef75c90d3aa"
    sha256 cellar: :any_skip_relocation, big_sur:       "d1b5422255a774bfc2a582936c2a639e70167a1a6ae01cc2a99d9d3bded9d3fb"
    sha256 cellar: :any_skip_relocation, catalina:      "7b30dd40fba19a354809b0d311afb061b3d67134a4e8dc522911240fc04f1c56"
    sha256 cellar: :any_skip_relocation, mojave:        "9a20691424cccdb57170661480740191517a617d2a1a079d29411fd376f4f78a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match(/\d+.+?\./, shell_output("#{bin}/dust -n 1"))
  end
end
