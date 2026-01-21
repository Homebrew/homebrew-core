class Garmintools < Formula
  desc "Interface to the Garmin Forerunner GPS units"
  homepage "https://code.google.com/archive/p/garmintools/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/garmintools/garmintools-0.10.tar.gz"
  sha256 "ffd50b7f963fa9b8ded3223c4786b07906c887ed900de64581a24ff201444cee"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "47a336083bb5161af82770d5c472d2ce4f358914bce8e2263458e5a757d45433"
    sha256 cellar: :any,                 arm64_sequoia:  "20a6201dcffaf971164afa65223ba7eb6ef53dca3c1a092e303dda0654f109d8"
    sha256 cellar: :any,                 arm64_sonoma:   "da0e5ffaf6e1b8477d92247072fcf400f9b16368bd93db8a05e9c3106efdb2c7"
    sha256 cellar: :any,                 arm64_ventura:  "6c16db8a8f76d0b5dfdae1ae49cf31ebe12ea2bf6ee35b791849fa66fb2fc6ee"
    sha256 cellar: :any,                 arm64_monterey: "9b16bdc132c970434babd5033664d00b697deeb0fd3796c8986b1a95b7941582"
    sha256 cellar: :any,                 arm64_big_sur:  "97d99c30f0c47262b295405d79c9a0dc7bbd5b38bc67f6d7fb3e96789e0cad97"
    sha256 cellar: :any,                 sonoma:         "90cfaa48740de68b7c593c3c94760bcfc5ab109e03b98cebdd56726868188789"
    sha256 cellar: :any,                 ventura:        "1fba9cf9c8ce7383afbde00c72aa5082b0a2a87fdae51ced08dee7dc00e9575a"
    sha256 cellar: :any,                 monterey:       "b49cda53d64a80e61cd1de700036714c6470d5b77fad8f6320d164cb1e50db15"
    sha256 cellar: :any,                 big_sur:        "eac3d937b3281a2a172185e01a53f86fda15247168ddf7cb4dedb2a8f81b9220"
    sha256 cellar: :any,                 catalina:       "91c193c86b431bc3541b18ad33cf6793b001fc70293c50289d8fe6d978d50ca5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "651d681008bab2dbe3a05031813af4ed84eca0b086c98dc3ccbdff327b4944dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "230b31dd83d9514c35abdb2477e4f1e4941eb1c94bf394814acd46676ced1318"
  end

  depends_on "libusb-compat"

  def install
    # Fix flat namespace usage
    inreplace "configure", "${wl}-flat_namespace ${wl}-undefined ${wl}suppress", "${wl}-undefined ${wl}dynamic_lookup"

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"garmin_dump"
  end
end
