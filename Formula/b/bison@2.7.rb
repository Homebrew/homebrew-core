class BisonAT27 < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftp.gnu.org/gnu/bison/bison-2.7.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/bison/bison-2.7.1.tar.gz"
  sha256 "08e2296b024bab8ea36f3bb3b91d071165b22afda39a17ffc8ff53ade2883431"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "472d73bf7ba67981ae3246014105d2c150a5d62293b5c5e2e9726fea022c29f0"
    sha256 arm64_ventura:  "4c2881dcd188abeb431f4f53f1b01186b7dc588f12e890021ae77b3f3b547005"
    sha256 arm64_monterey: "52c4f32eb121a9442b25748e155a1d9d4ace7d433a07eafc13faed18272a2714"
    sha256 arm64_big_sur:  "a8889d09761ad553f7b7061947a1715e88a658ce7f4d3755b7d8d00f25a53f1a"
    sha256 sonoma:         "d766c79c2137d8856917b57cfd63237d63d14f92469ca2eb9e0d0536049e5648"
    sha256 ventura:        "355f1fc5d497c0ce49e161173ff9c98a737dc8ec037ce2edde491f6bf65b6f79"
    sha256 monterey:       "fe295780aa756db1594d7a0db99e2f19c282b54f4c405d35a9248048714b680e"
    sha256 big_sur:        "01d3b84f13676a4da576df0d7f8f9fafcc7ea734b895a5d3947b1e055d9db330"
    sha256 catalina:       "b9af668b0da3e89f4a2d7b7e4d42009965780d1f7cd1541df85f758c2b7af55a"
    sha256 mojave:         "125fdf2eb737cdb8a3e795234f8e1fb5ec477f8590c534f7895497a6af82e04b"
    sha256 high_sierra:    "ee0e758aa798809aaa3e94f1e3659c9d33497a577c25cfc03ecfe18c25862837"
    sha256 sierra:         "7f1f717becaf0a818b154d3706b88f6c61a102b4f909e030005aaa5433abc34e"
    sha256 el_capitan:     "3b49ff1a76807438bfb6805e513d372fba8d49c0259fe4f28e1587d47e42bf5c"
    sha256 x86_64_linux:   "5ab86dee3b17c3d3a610b1db7f949a95d71be7ac1c978d81fc2ae400941c4d97"
  end

  keg_only :versioned_formula

  deprecate! date: "2023-12-14", because: :versioned_formula

  uses_from_macos "m4"

  patch :p0 do
    on_high_sierra :or_newer do
      url "https://raw.githubusercontent.com/macports/macports-ports/b76d1e48dac/editors/nano/files/secure_snprintf.patch"
      sha256 "57f972940a10d448efbd3d5ba46e65979ae4eea93681a85e1d998060b356e0d2"
    end
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.y").write <<~EOS
      %{ #include <iostream>
         using namespace std;
         extern void yyerror (char *s);
         extern int yylex ();
      %}
      %start prog
      %%
      prog:  //  empty
          |  prog expr '\\n' { cout << "pass"; exit(0); }
          ;
      expr: '(' ')'
          | '(' expr ')'
          |  expr expr
          ;
      %%
      char c;
      void yyerror (char *s) { cout << "fail"; exit(0); }
      int yylex () { cin.get(c); return c; }
      int main() { yyparse(); }
    EOS
    system "#{bin}/bison", "test.y"
    system ENV.cxx, "test.tab.c", "-o", "test"
    assert_equal "pass", shell_output("echo \"((()(())))()\" | ./test")
    assert_equal "fail", shell_output("echo \"())\" | ./test")
  end
end
