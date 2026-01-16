class Libyubikey < Formula
  desc "C library for manipulating Yubico one-time passwords"
  homepage "https://yubico.github.io/yubico-c/"
  url "https://developers.yubico.com/yubico-c/Releases/libyubikey-1.13.tar.gz"
  sha256 "04edd0eb09cb665a05d808c58e1985f25bb7c5254d2849f36a0658ffc51c3401"
  license "BSD-2-Clause"

  livecheck do
    url "https://developers.yubico.com/yubico-c/Releases/"
    regex(/href=.*?libyubikey[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "6f293dfc1a720368bb989bdb389bb507d785ac6cbab9d33753f56084255296f3"
    sha256 cellar: :any,                 arm64_sequoia:  "1402744ea6becf5fc6caf82c61b90530180bc7b7c025952ab5f47db813d9dd81"
    sha256 cellar: :any,                 arm64_sonoma:   "9963f3715eff70ebf4bbe725e8bf6e3bb112cb3476798b7d8705090dc3049ed0"
    sha256 cellar: :any,                 arm64_ventura:  "4580266e70e2afadf36db6e307f1e2f5046e06628b1482d55c11af8714c9fd87"
    sha256 cellar: :any,                 arm64_monterey: "b1df3ed34996e203f862b623d96606645e25f564e8b2827539c4744c3712fd28"
    sha256 cellar: :any,                 arm64_big_sur:  "281fc4490bcdf4c4b19c5aa08a10a996e8fb10c9e1385ba95abd973186e18932"
    sha256 cellar: :any,                 sonoma:         "e23c0a9cbcea4d8c864bb323cb36f800c75a7454eef58716a5bf32a2b4658a49"
    sha256 cellar: :any,                 ventura:        "4a3cef8d90a4771f8af5102c61544d8c2479333553fd2671ecf8faaf6bdb8388"
    sha256 cellar: :any,                 monterey:       "e698d9e14c769152fe36caa69cb4b0232747f76fd0b2e8cc02518dc42f758ff9"
    sha256 cellar: :any,                 big_sur:        "d8294cc5022aa96ca4d2073756da801daef11a07e3464656af749008b84cde6d"
    sha256 cellar: :any,                 catalina:       "b6fccb68ae85837533ea4680063cc64f207f2d6926c4eafaf23e81f0b790fc55"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ba8cb3360047820a6e9bbc5147e99a5a4538c6061c60088aee8ed9ff65970061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47be6e603ede5ef7fee2f40cfd4ac4338ca094d25b2a897388df4b90ca5101b7"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
