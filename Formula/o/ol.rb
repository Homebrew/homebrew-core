class Ol < Formula
  desc "Purely functional dialect of Lisp"
  homepage "https://yuriy-chumak.github.io/ol/"
  url "https://github.com/yuriy-chumak/ol/archive/refs/tags/2.5.1.tar.gz"
  sha256 "d9fe66bd15cf9c9c30bf45b97e5825c2101b518fc27c671c08a95798eec3c510"
  license any_of: ["LGPL-3.0-or-later", "MIT"]
  head "https://github.com/yuriy-chumak/ol.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "81826d1dabeac36decb539b87e72acd37bdd505c44738ceec818fe181c007388"
    sha256 arm64_sonoma:   "4a26bf8cd860169a30d295300867cd39b9055edcb33df3bfcf52f0e22041c358"
    sha256 arm64_ventura:  "89ef88d3303f2ba434c19ff40955cc125c65d856c1f9884fb20ad8081c0218fb"
    sha256 arm64_monterey: "5bd128ae10e3d5f087cd52701e013d42615a847628f0c082a6ef33a29d8c616e"
    sha256 sonoma:         "d866de08080658e4cbecff302edfa6b8ed529c51dd69edc8cacf4aa779394773"
    sha256 ventura:        "538fffac7c285ae77ba0cad5c7a3c98c34fad5e9fe88476a5c70e30648a299ea"
    sha256 monterey:       "2d129e262e46479b55d23bcdb13a6b6e42b85c0abbb8d693b4504aee80b73147"
    sha256 x86_64_linux:   "a5a4a3fdfef063020bc921b033b5b1ffab264e9f33813b19798e0965ed32a7e9"
  end

  uses_from_macos "vim" => :build # for xxd

  conflicts_with "radamsa", because: "both install `ol` binaries"

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "make", "all", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"gcd.ol").write <<~EOS
      (print (gcd 1071 1029))
    EOS
    assert_equal "21", shell_output("#{bin}/ol gcd.ol").strip
  end
end
