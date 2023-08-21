class Cpio < Formula
  desc "Copies files into or out of a cpio or tar archive"
  homepage "https://www.gnu.org/software/cpio/"
  url "https://ftp.gnu.org/gnu/cpio/cpio-2.14.tar.bz2"
  mirror "https://ftpmirror.gnu.org/cpio/cpio-2.14.tar.bz2"
  sha256 "fcdc15d60f7267a6fc7efcd6b9db7b6c8966c4f2fbbb964c24d41336fd3f2c12"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71ccaa3f3733ddd2a6ccd886120e7cdca68b775ac2615d46cf99902df6f65417"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b6dc737f78221ccbcbef7ddf0f6c5fb345b8db86cfa32f6f64be37b9556dd50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b4544de5d652bff8b6cc48a0e5396e271cfca0e089e7d3a1029e277cdfc7ddd"
    sha256 cellar: :any_skip_relocation, ventura:        "b4d80de07725c95bd4454c578ad37ca73c506443ef200c10690da2799ca25ade"
    sha256 cellar: :any_skip_relocation, monterey:       "88d4ee2cbdc7eefcd0c81d466cdbb433ba75fd6d0f1cad603d3691cb1126911c"
    sha256 cellar: :any_skip_relocation, big_sur:        "06004c76848994f1f3d1f3b69050f63956818ea618d52196d1ab5ef7998965df"
    sha256                               x86_64_linux:   "a9bddcdf8ece9ce9ba43ff2cc1ca8ff985e8d8c2269e9c716b74ad470e766159"
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
