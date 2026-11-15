class Execline < Formula
  desc "Interpreter-less scripting language"
  homepage "https://skarnet.org/software/execline/"
  url "https://skarnet.org/software/execline/execline-2.10.0.0.tar.gz"
  sha256 "561be2ce578604644e2263a889bbdf4736e7980401ee88556a7f9017c166dbab"
  license "ISC"
  compatibility_version 1
  head "git://git.skarnet.org/execline", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?execline[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1beaa54d4fce539e9d73b51061b85a96547f963eab99c1e27077112bfd26d260"
    sha256 cellar: :any, arm64_tahoe:       "ba5af333c7b57916d7973b957f2a228dc3cb06f127460c8230e1f64d5e8003e5"
    sha256 cellar: :any, arm64_sequoia:     "c6d8358a272179ca4f0a75674b7c7adb51f00b9a2b5a5598f2947838e985edaf"
    sha256 cellar: :any, arm64_linux:       "a6a362e8309c4b786acdaf5c11804690847eb4fb802c1e4b804ee4a057ec4cfb"
    sha256 cellar: :any, x86_64_linux:      "d259e9a2fa51e59dc07fa2bf30fcf93d4dffbf89bf09bc12775d2f2d3e77a300"
  end

  depends_on "pkgconf" => :build
  depends_on "skalibs"

  deny_network_access!

  def install
    args = %W[
      --disable-silent-rules
      --enable-shared
      --enable-pkgconfig
      --with-pkgconfig=#{formula_opt_bin("pkgconf")}/pkg-config
      --with-sysdeps=#{formula_opt_lib("skalibs")}/skalibs/sysdeps
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.eb").write <<~EOS
      foreground
      {
        sleep 1
      }
      "echo"
      "Homebrew"
    EOS
    assert_match "Homebrew", shell_output("#{bin}/execlineb test.eb")
  end
end
