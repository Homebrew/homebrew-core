class Homeworlds < Formula
  desc "C++ framework for the game of Binary Homeworlds"
  homepage "https://github.com/Quuxplusone/Homeworlds/"
  url "https://github.com/Quuxplusone/Homeworlds.git",
      revision: "917cd7e7e6d0a5cdfcc56cd69b41e3e80b671cde"
  version "20141022"
  license "BSD-2-Clause"
  revision 5

  livecheck do
    skip "No version information available to check"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "1c9858b9293f5f31151e0365d9be0d80065fb353a0f5bb28d5f50c6bed5e91cf"
    sha256 cellar: :any,                 arm64_sonoma:   "4547a4dfb3768f8922cbc668493ef5021b7dee7d51ce6ef237ce78a652636f4a"
    sha256 cellar: :any,                 arm64_ventura:  "9a34aebc0071531698225b1e64a19a45c6eff1efecf4e948ee963d590e18f22f"
    sha256 cellar: :any,                 arm64_monterey: "c64318bee66cc6f65c77c7cb846b87a3a756f0fe92045824f32963341564669d"
    sha256 cellar: :any,                 arm64_big_sur:  "cccfb68554076f1c70337b70ca450779546af81986e81973cb7b25acb9a0220f"
    sha256 cellar: :any,                 sonoma:         "5c6ecc5f99b386c4e05c2cb9a8df1e10269cf57845171d3d5885dc3b6cd801f6"
    sha256 cellar: :any,                 ventura:        "17d89e3982a30bade2c248ad02edde9c429128e0b25efb997f146c89eddeb016"
    sha256 cellar: :any,                 monterey:       "4ee671d1292a1e9c8f63ea3e1a40625d20b4349e3a3d188077646936ae9f60c5"
    sha256 cellar: :any,                 big_sur:        "311295581320a095f2754a7adc5c1c291d2ad9a9baa368daee04c0c73c78ceca"
    sha256 cellar: :any,                 catalina:       "117c083e402e42c76765855805ecda628538eab7372fc80cceef84a100b9368f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88f7a3976037aea175f742cb16c1e3e0e7e0f7945bf9f24b42eaedeabe16834c"
  end

  depends_on "wxwidgets"

  def install
    system "make"
    bin.install "wxgui" => "homeworlds-wx", "annotate" => "homeworlds-cli"
  end
end
