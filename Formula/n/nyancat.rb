class Nyancat < Formula
  desc "Renders an animated, color, ANSI-text loop of the Poptart Cat"
  homepage "https://nyancat.dakko.us/"
  url "https://github.com/klange/nyancat/archive/refs/tags/1.5.2.tar.gz"
  sha256 "88cdcaa9c7134503dd0364a97fa860da3381a09cb555c3aae9918360827c2032"
  license "NCSA"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4063d47ab6f498ff5b7dc2baef313c16f68e20bf302f219c43ef7f6ef24c611d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bc5741eb96d5bd24301b288f9d2500c635c2b9c0ffc1654ed4ee1b1bfd02c303"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63f328a8b248972e6d29b28116cd2e6b7396a7a09e2d8a02e85e037ced6d4016"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7975892c912c11d73fae58e5cf972b6dc3beb8e9d10f03883002ad53f843f8f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c2fef45873d4944b918cdaad1f458b5ae1e863fbde1c91130ac0a73bc571e5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e15caf1bc3a60334cb7e38466e50005cfbb15dd5e143abc876983fcb3d3a41d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "c667cbec3790985e18b2d88173f7d3bb1d277661e074a161d8972502fedfd757"
    sha256 cellar: :any_skip_relocation, ventura:        "6ef00c54df968d02e4fe641bcda68baf7f77cd54df43e1c657c74ae0572e2573"
    sha256 cellar: :any_skip_relocation, monterey:       "777e0a4b2074525b1b9db1d5dc6e7756d3f8c3d1c03667cc28d80781b0cf7dd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "9eef2795f2dc32491b4b948d39a8f68f6274964174ff735d3f42ee70c7035148"
    sha256 cellar: :any_skip_relocation, catalina:       "997fc4e89ef493a356e781543d69343e96a08547aba3bec53bd1db64b48f3436"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f8ec43d463c0a65e4c50c3e3d2675fb3f89fba1503fc036b1b717eecda6a1511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69b8c44133a399fddd0b6b6db41d2dcd9ba2420a5c5b53e62409d14cfacadc85"
  end

  # Makefile: Add install directory option
  # See https://github.com/klange/nyancat/pull/34
  patch do
    url "https://github.com/klange/nyancat/commit/e11af77f2938ea851f712df62f08de4d369598d4.patch?full_index=1"
    sha256 "24a0772d2725e151b57727ce887f4b3911d19e875785eb7e13a68f4b987831e8"
  end

  def install
    system "make"
    system "make", "install", "instdir=#{prefix}"
  end

  test do
    system bin/"nyancat", "--frames", "1", "--width", "40", "--height", "20", "--no-clear"
  end
end
