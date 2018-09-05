class Ib < Formula
  desc "C/C++ build tool that automatically resolves included source"
  homepage "https://github.com/JasonL9000/ib"
  url "https://github.com/JasonL9000/ib/archive/0.7.1.tar.gz"
  sha256 "a5295f76ed887291b6bf09b6ad6e3832a39e28d17c13566889d5fcae8708d2ec"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "9ef753d03b8c2d62f37fc8d2eb112f14ca6fb9227d409a42e6c75c6f0b4f48e1" => :mojave
    sha256 "51b002426c06c820d4133e3b88ac9264aad81b7c554d08991ced951a0f43e0e1" => :high_sierra
    sha256 "51b002426c06c820d4133e3b88ac9264aad81b7c554d08991ced951a0f43e0e1" => :sierra
    sha256 "51b002426c06c820d4133e3b88ac9264aad81b7c554d08991ced951a0f43e0e1" => :el_capitan
  end

  depends_on "python@2"

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
