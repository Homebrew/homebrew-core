class Astroterm < Formula
  desc "Planetarium for your terminal"
  homepage "https://github.com/da-luce/astroterm"
  url "https://github.com/da-luce/astroterm/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "3b8b1597afb31d1cb8ad54030b5766652b4d3f42f0a3d510bbc3191c0c6a4aa5"
  license "MIT"
  head "https://github.com/da-luce/astroterm.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "91761c77d2816c3ed68f269657e1ff8234ba3391f4e56db01d1b0730ccdbfc10"
    sha256 cellar: :any,                 arm64_sonoma:  "cf6d3db88af6cead0e19c79763bc24d87e9d8a57be5fc78d8d81e934a4185275"
    sha256 cellar: :any,                 arm64_ventura: "ff0eae541a834f232688fd1a64be1d4959da0a683648fc2406813ab77c07bd9a"
    sha256 cellar: :any,                 sonoma:        "dcff897a85fb13ab2b7341577849de53bd4158c2384f60ce09ac39f3a0c764e1"
    sha256 cellar: :any,                 ventura:       "c48bcaf9ef3af7dd55969efe833400bd5711f4c5b2882929ccd6d65ae71195fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97560d671623bd96285f2eae104209c7d95b5718eefddf6cfc61d247fb60ca8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f841a9d3d79cf04ed5f6b03c83ae86c3a859f87930e2652d9b1e895353c51d04"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "argtable3"

  uses_from_macos "vim" => :build # for xxd
  uses_from_macos "ncurses"

  resource "bsc5" do
    url "http://tdc-www.harvard.edu/catalogs/BSC5", using: :nounzip
    sha256 "e471d02eaf4eecb61c12f879a1cb6432ba9d7b68a9a8c5654a1eb42a0c8cc340"
  end

  def install
    resource("bsc5").stage do
      (buildpath/"data").install "BSC5"
      mv buildpath/"data/BSC5", buildpath/"data/bsc5" if OS.linux?
    end

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # astroterm is a TUI application
    assert_match version.to_s, shell_output("#{bin}/astroterm --version")
  end
end
