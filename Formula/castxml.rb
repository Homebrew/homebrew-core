class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://deb.debian.org/debian/pool/main/c/castxml/castxml_0.1+git20180702.orig.tar.xz"
  version "0.1+git20180702"
  sha256 "00c58b28523496fbeda731656bb022ad55e7c390609f189ebe03b4468292da40"
  revision 1

  head "https://github.com/CastXML/castxml.git"

  bottle do
    cellar :any
    sha256 "48412e52013e09c3830b4eb5653bd447c2b5be398db9b05f71ca1065fa582867" => :mojave
    sha256 "094c47bde5f666aad5078e7b8652f71aca7f14cecb233977e7949e6e721ec685" => :high_sierra
    sha256 "0664be25be8a34110f61ff8cfba1b871aa956b9dfa0e8e0b89e3c75a8b2f6b4f" => :sierra
    sha256 "7c6ed31aa80033884da9f2a3265caaf7a5796736ca1d0f1743e1d93aad2cf993" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  patch do
    # 1st patch from CastXML/CastXML#122 needed to fix build with llvm 7
    url "https://github.com/CastXML/CastXML/commit/ae5c050fc099483605632671bda106449a81f598.diff?full_index=1"
    sha256 "54d9b5822ff4f3485d1e5ea0dcd72f3a0e533d0ba9f38ead5ba4a004a5155cdf"
  end

  patch do
    # 2nd patch from CastXML/CastXML#122 needed to fix build with llvm 7
    url "https://github.com/CastXML/CastXML/commit/98a626ecb1aa522ca4f2575aeddc4ca3bb8c76db.diff?full_index=1"
    sha256 "ba62fdc5f1d1ae7a545b168cc11093098236be5d0c695a7ac30d352b0730dc6e"
  end

  patch do
    # 3rd patch from CastXML/CastXML#122 needed to fix build with llvm 7
    url "https://github.com/CastXML/CastXML/commit/a345f628237a36c9ca55364760e41ff7a936e7da.diff?full_index=1"
    sha256 "3ea026508df2c097c34ef7340f104f7a05db5949e58ee4f97fe6380eb7b09be1"
  end

  patch do
    # 4th patch needed to fix build with llvm 7
    url "https://github.com/CastXML/CastXML/commit/1770dacb2b74f5394dd577a0aa6808f70aa37d43.diff?full_index=1"
    sha256 "66b96c8ad4e1ca03f506c3d2e7b10e7f88c70825340b2c679726d898a8d22b74"
  end

  patch do
    # 5th patch needed to fix build with llvm 7
    url "https://github.com/CastXML/CastXML/commit/c3a239d4b9a484247031c00735a41d3cee2f2a45.diff?full_index=1"
    sha256 "1d86fe284bb1bd88f63f46d707fa91eb2c3c8c03a9abb442ac352d92cb553886"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system "#{bin}/castxml", "-c", "-x", "c++", "--castxml-cc-gnu", "clang++", "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end
