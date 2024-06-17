class Chrony < Formula
  desc "Versatile implementation of the Network Time Protocol (NTP)"
  homepage "https://chrony-project.org"
  url "https://chrony-project.org/releases/chrony-4.5.tar.gz"
  sha256 "19fe1d9f4664d445a69a96c71e8fdb60bcd8df24c73d1386e02287f7366ad422"
  license "GPL-2.0-only"

  livecheck do
    url "https://chrony-project.org/download.html"
    regex(/href=.*?chrony[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "bc58ccdf1b33884df65fb79542cfc45af28590788d116480dc2e446b013f150f"
    sha256 cellar: :any,                 arm64_ventura:  "42da0b2102be878e2e0257d04d6cca105e0bb3a0c20ce794ea808f457a2cf901"
    sha256 cellar: :any,                 arm64_monterey: "ecd3bb560ede140523b97307b027f4ee8b2f252cec6756276a168a9dd1797063"
    sha256 cellar: :any,                 sonoma:         "fb8e16572fe7fbeb87bfd146a2896672b3f5c48d8c08fac207c23731349f3054"
    sha256 cellar: :any,                 ventura:        "c1e580842a2eabec7365f5095bab50930e87e9c4d0006e482c30a2018a6f2ebd"
    sha256 cellar: :any,                 monterey:       "b214a11d12b514dc499ed28ea3d6ee66e667a55c553146ed5160d0d9f5dafc8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ead26245ab117713fb7783c065a33e60b1b2144f74d2ebfc6388e9909c8549a"
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "nettle"

  uses_from_macos "libedit"

  def install
    system "./configure", "--localstatedir=#{var}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.conf").write "pool pool.ntp.org iburst\n"
    output = shell_output(sbin/"chronyd -Q -f #{testpath}/test.conf 2>&1")
    assert_match(/System clock wrong by -?\d+\.\d+ seconds \(ignored\)/, output)
  end
end
