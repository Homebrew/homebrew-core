class Cpio < Formula
  desc "Copies files into or out of a cpio or tar archive"
  homepage "https://www.gnu.org/software/cpio/"
  url "https://ftp.gnu.org/gnu/cpio/cpio-2.13.tar.bz2"
  mirror "https://ftpmirror.gnu.org/cpio/cpio-2.13.tar.bz2"
  sha256 "eab5bdc5ae1df285c59f2a4f140a98fc33678a0bf61bdba67d9436ae26b46f6d"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a52647dfa0fc91821508e340b67e09ddb7827b66644ef4006df040502dc5f249"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f22c470e6b85be477298907f64e9d6c0c8261d81f244ee9f7977b37f64bc2d53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f0f5625adf815f5dcbce9016b20df0ea0f41475343954e057422f9bd006ab87"
    sha256 cellar: :any_skip_relocation, ventura:        "cc465355f48db5e8ebc6f67682cfaaa8db999bdd59980999808a3dfeba5ba92d"
    sha256 cellar: :any_skip_relocation, monterey:       "1b04d03bdfdb091451d3c6602e7dfbefe18c3a719c5382c6636245b9d5403c91"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc6d56c513f95660d835533ad45717ac448767692216f22f39971e28da045bb0"
    sha256 cellar: :any_skip_relocation, catalina:       "63775ad863bde22691bf678e67982fbb21488c2e86843133bd34461aa5a61586"
    sha256                               x86_64_linux:   "42071ea523978d2b2ea5a5129cb29084fef728f270577709fc1595d5a8cfbef2"
  end

  keg_only :shadowed_by_macos, "macOS provides cpio"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"

    return if OS.mac?

    # Delete rmt, which causes conflict with `gnu-tar`
    (libexec/"rmt").unlink
    (man8/"rmt.8").unlink
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <string>
    EOS
    system "ls #{testpath} | #{bin}/cpio -ov > #{testpath}/directory.cpio"
    assert_path_exists "#{testpath}/directory.cpio"
  end
end
