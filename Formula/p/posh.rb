class Posh < Formula
  desc "Policy-compliant ordinary shell"
  homepage "https://salsa.debian.org/clint/posh"
  url "https://salsa.debian.org/clint/posh/-/archive/debian/0.14.3/posh-debian-0.14.3.tar.bz2"
  sha256 "6030fa51a03d0625794df0f52c74103d230390dbc0e22cdce946f5f5e6ff33ff"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{^debian/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "180e38dcaededb7bf2f1ed55b02adcb756136ddca91ac11e8bbeba57a525afaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ec6609559b42164f4d1a9e855eaa0754867562b40c23919b7cb0791e93409bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a12b2e8b08a4f7f04c6d3aa5e74f4754e70c007711367efc1971df614f2fbaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f665cf7536a4dd8f70f99b8d39af44c06980cc8e7e01905c7acc9f342a47f6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "752c708a0cbe2e63ac77e1261e5a9c3773a4cd331de54b9b9f90282a90cb3940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "359384c23a46977a8891636407294023a59917d078758f4deed7db1fae57a1ba"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/posh -c 'echo homebrew'")
    assert_equal "homebrew", output.chomp
  end
end
