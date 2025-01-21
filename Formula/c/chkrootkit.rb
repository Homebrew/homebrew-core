class Chkrootkit < Formula
  desc "Rootkit detector"
  homepage "https://www.chkrootkit.org/"
  url "ftp://ftp.chkrootkit.org/pub/seg/pac/chkrootkit-0.58.tar.gz"
  mirror "https://fossies.org/linux/misc/chkrootkit-0.58.tar.gz"
  sha256 "0325cd19ace8928ca036aa956ec8cd9a3d9fe02965e30a4720e9baf34ed56a42"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?download[^>]*>chkrootkit v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fe29a10c285df79b49a35471df0da20208774ec8436932cddc09e4bc2099a215"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c24f28d8f90e8f0aa3eea0978e1f518dce8a288919927b24ebb5d77a6aa9121"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbd2dd4ac20e747293eedd01d9ccc8c9bfbd56d75b4cc269f33c9e3cd793ceda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7d9ddf16ed810c46ebc3aa73063bb35887722d115a317b5c4ab9d099c12bb82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cc2ca082dcb083a06732f58d51ce7ed9f3a4ee3eccd2aea4e3b7d8fd14861c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e8632f9ef69b72066519be738516b81e15485b41d03d5cc6c89ac40b0b59089"
    sha256 cellar: :any_skip_relocation, ventura:        "d4fb446dedba887717246dabc02a955b435fddb76d3d24f227e3048b02cc5d03"
    sha256 cellar: :any_skip_relocation, monterey:       "792f77c1f50ff0cd9c93974d1729e65cccceb9c89acb102ad3d86d8a6ffe8241"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c891dc0f3d653c9e072cef412a9ffe697dccc170a2c28fbc5710a6b61249072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69c27f598f7f53881f961c3b9db7b9f637cbe05c83f0264b678dee6911d01e0b"
  end

  def install
    ENV.deparallelize

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}",
                   "STATIC=", "sense", "all"

    bin.install Dir[buildpath/"*"].select { |f| File.executable? f }
    doc.install %w[README README.chklastlog README.chkwtmp]
  end

  test do
    assert_equal "chkrootkit version #{version}",
                 shell_output("#{bin}/chkrootkit -V 2>&1", 1).strip
  end
end
