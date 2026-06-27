class Ol < Formula
  desc "Purely functional dialect of Lisp"
  homepage "https://yuriy-chumak.github.io/ol/"
  url "https://github.com/yuriy-chumak/ol/archive/refs/tags/2.7.tar.gz"
  sha256 "32dec0d527d456cce3273b907ffface6386a61288edf33f8724e2dd1bfb22319"
  license any_of: ["LGPL-3.0-or-later", "MIT"]
  head "https://github.com/yuriy-chumak/ol.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "808c5ab08ff5d58de1d7c4338b6e7d34b25a8a64fc61439c880ca3cc14aaf552"
    sha256 arm64_sequoia: "3cd197ba2829aa7db2500cc2ac045fb1309b564915b457872482f93e1651a7b7"
    sha256 arm64_sonoma:  "34a663be5942724bb4e9c0ea962ddde5f50fc53fee0470588e0932258cad2a60"
    sha256 sonoma:        "146f18c3429ccddef2bbdb59976b8fd3f8fa3afd749de934175609bc456d2d04"
    sha256 arm64_linux:   "64ca5080e8a6e6eee3453678670e9899ab283bb08b513f6986e22778a764616b"
    sha256 x86_64_linux:  "9c1676ecd6d7eed148c840759b3f810ce054e863a32d9d478d620e84adf4d214"
  end

  uses_from_macos "vim" => :build # for xxd

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "make", "all", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"gcd.ol").write <<~LISP
      (print (gcd 1071 1029))
    LISP
    assert_equal "21", shell_output("#{bin}/ol gcd.ol").strip
  end
end
