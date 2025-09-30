class Dmenu < Formula
  desc "Dynamic menu for X11"
  homepage "https://tools.suckless.org/dmenu/"
  url "https://dl.suckless.org/tools/dmenu-5.4.tar.gz"
  sha256 "8fbace2a0847aa80fe861066b118252dcc7b4ca0a0a8f3a93af02da8fb6cd453"
  license "MIT"
  head "https://git.suckless.org/dmenu/", using: :git, branch: "master"

  livecheck do
    url "https://dl.suckless.org/tools/"
    regex(/href=.*?dmenu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "48572596abd24b3c86d85ca49f4ea5eccb8b531e2589df523adc5dee2f2b011d"
    sha256 cellar: :any,                 arm64_sequoia: "0c348d9eed878159d80ecef04a223a46f9746d97718454df5dc4244e6c735b4a"
    sha256 cellar: :any,                 arm64_sonoma:  "1565ec173e8afb3953ac135a1a3944cb0847e0363ecc5e2fec4f2442c8e63bef"
    sha256 cellar: :any,                 arm64_ventura: "e451aa665b8c54cb02549ff7d8505f6c67fd429d3df5e6fd3fcc84897ea87a54"
    sha256 cellar: :any,                 sonoma:        "164c867ca65c1a5b9cb815dbdb188d988a19e11b608a530835ddfb90ec935b3d"
    sha256 cellar: :any,                 ventura:       "359269551ea3e028114d423cc0104176d0d6537b6d7a989847dc63555a9fc1f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "775a0ea9139f8e05234fcf09917ae846b11d50caa08dcefdb22ac6c5836d8fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90f70c92c682c828f0e538a032421fd468268959c45b4ba2dd36647a34e28d9d"
  end

  depends_on "fontconfig"
  depends_on "libx11"
  depends_on "libxft"
  depends_on "libxinerama"

  def install
    system "make", "FREETYPEINC=#{HOMEBREW_PREFIX}/include/freetype2", "PREFIX=#{prefix}", "install"
  end

  test do
    # Disable test on Linux because it fails with this error:
    # cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "warning: no locale support", shell_output("#{bin}/dmenu 2>&1", 1)
  end
end
