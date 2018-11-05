class Lcm < Formula
  desc "Libraries and tools for message passing and data marshalling"
  homepage "https://lcm-proj.github.io/"
  url "https://github.com/lcm-proj/lcm/releases/download/v1.4.0/lcm-1.4.0.zip"
  sha256 "e249d7be0b8da35df8931899c4a332231aedaeb43238741ae66dc9baf4c3d186"

  head "https://github.com/lcm-proj/lcm.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8223454e139a3efd0972f0885b9d624377bed55496ff5bb0d3c9a5f6265a67c7" => :mojave
    sha256 "efd68dbb5defc150bc7be3d8ab2e9d5b5faa1d751fb49cb21eb0c9997b0617e8" => :high_sierra
    sha256 "73d7b08663a9f318a5804476f29f55d08c733aebc2037405b4147f52942b09a0" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on :java => "1.8"

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_CXX_FLAGS=-I/System/Library/Frameworks/Python.framework/Headers",
                            "-DLCM_ENABLE_TESTS=OFF",
                            *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"example_t.lcm").write <<~EOS
      package exlcm;

      struct example_t
      {
          int64_t timestamp;
          double position[3];
          string name;
      }
    EOS
    system "#{bin}/lcm-gen", "-c", "example_t.lcm"
    assert_predicate testpath/"exlcm_example_t.h", :exist?, "lcm-gen did not generate C header file"
    assert_predicate testpath/"exlcm_example_t.c", :exist?, "lcm-gen did not generate C source file"
    system "#{bin}/lcm-gen", "-x", "example_t.lcm"
    assert_predicate testpath/"exlcm/example_t.hpp", :exist?, "lcm-gen did not generate C++ header file"
    system "#{bin}/lcm-gen", "-j", "example_t.lcm"
    assert_predicate testpath/"exlcm/example_t.java", :exist?, "lcm-gen did not generate java file"
  end
end
