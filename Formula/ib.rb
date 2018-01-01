class Ib < Formula
  desc "C/C++ build tool that automatically resolves included source"
  homepage "https://github.com/JasonL9000/ib"
  url "https://github.com/JasonL9000/ib/archive/0.7.1.tar.gz"
  sha256 "a5295f76ed887291b6bf09b6ad6e3832a39e28d17c13566889d5fcae8708d2ec"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "e74609f716997f8ce4d22a3551294a518192749cddff5728b4e536c166974a61" => :high_sierra
    sha256 "7f58efad0d2261f73025fddedbad2d99762660bd4f1786795a79f1422d6ef1b6" => :sierra
    sha256 "7f58efad0d2261f73025fddedbad2d99762660bd4f1786795a79f1422d6ef1b6" => :el_capitan
    sha256 "7f58efad0d2261f73025fddedbad2d99762660bd4f1786795a79f1422d6ef1b6" => :yosemite
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    prefix.install "common.cfg", "debug.cfg", "release.cfg", "asan.cfg", "__ib__"
    bin.install "ib"
  end

  test do
    mkdir testpath/"example" do
      (testpath/"example/debug.cfg").write <<~EOS
        cc = Obj(
          tool='clang',
          flags=[ '--std=c++14' ],
          hdrs_flags=[ '-MM', '-MG' ],
          incl_dirs=[]
        )

        link = Obj(
          tool='gcc',
          flags=[ '-pthread' ],
          libs=[ 'stdc++' ],
          static_libs=[],
          lib_dirs=[]
        )

        make = Obj(
          tool='make',
          flags=[],
          all_pseudo_target='all'
        )
      EOS

      (testpath/"example/hello.cc").write <<~EOS
        #include <iostream>

        int main(int, char*[]) {
          std::cout << "Hello World!" << std::endl;
          return 0;
        }
      EOS

      touch testpath/"example/__ib__"
      system "#{bin}/ib", "hello"
      system "../out/debug/hello"
    end
  end
end
