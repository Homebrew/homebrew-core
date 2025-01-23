class Nuspell < Formula
  desc "Fast and safe spellchecking C++ library"
  homepage "https://nuspell.github.io/"
  url "https://github.com/nuspell/nuspell/archive/refs/tags/v5.1.6.tar.gz"
  sha256 "5d4baa1daf833a18dc06ae0af0571d9574cc849d47daff6b9ce11dac0a5ded6a"
  license "LGPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "36f7270654e68ddfc9778b1e8e44d50b84e2f3af1d9da22e7ef904352665ee1e"
    sha256 cellar: :any,                 arm64_sonoma:  "fdef7d9831fbc25f5d118a8588614fe70cb274c26746d20fbedb1d4e820e3aad"
    sha256 cellar: :any,                 arm64_ventura: "25326f25f21894062a81c8f854d2d2c0fbcd4fa42e36178e67ab10badb99aade"
    sha256 cellar: :any,                 sonoma:        "0133410cf4271b33aae4c074884a8e5c6cd4eea1f02c7c4bb6ccb9caa845dafe"
    sha256 cellar: :any,                 ventura:       "5a22de305a727f7a0b1b7bba8712fc5a6dece9c3e7df3c0c23798cd93009dbbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e4173a44483183ed87307a0880afcaa4c8504c10186da722dc5893edaaeac0b"
  end

  depends_on "cmake" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :test
  depends_on "icu4c@76"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LC_CTYPE"] = "en_US.UTF-8"

    (testpath/"test.txt").write("helloo\nworlld")
    assert_match <<~EOS, shell_output("#{bin}/nuspell test.txt 2>&1", 1)
      INFO: Locale LC_CTYPE=en_US.UTF-8, Input encoding=UTF-8, Output encoding=UTF-8
      ERROR: Dictionary en_US not found
    EOS

    test_dict = testpath/"en_US.aff"
    test_dict.write <<~EOS
      SET UTF-8

      SFX A Y 1
      SFX A 0 s .

      PFX B Y 1
      PFX B 0 un .

      FLAG long

      TRY abcdefghijklmnopqrstuvwxyz
    EOS

    test_dic = testpath/"en_US.dic"
    test_dic.write <<~EOS
      1
      hello
    EOS

    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <fstream>
      #include <nuspell/dictionary.hxx>

      int main() {
        auto aff_path = std::string("#{testpath}/en_US.aff");
        auto dic_path = std::string("#{testpath}/en_US.dic");
        auto dict = nuspell::Dictionary();

        std::ifstream aff_file(aff_path);
        std::ifstream dic_file(dic_path);

        try {
          dict.load_aff_dic(aff_file, dic_file);
          std::cout << "Nuspell library loaded dictionary successfully." << std::endl;
        } catch (const std::exception &e) {
          std::cerr << "Failed to load dictionary: " << e.what() << std::endl;
          return 1;
        }

        return 0;
      }
    CPP

    icu4c = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                .to_formula
    ENV.prepend_path "PKG_CONFIG_PATH", icu4c.opt_lib/"pkgconfig"
    flags = shell_output("pkg-config --cflags --libs nuspell").chomp.split
    flags << "-Wl,-rpath,#{lib},-rpath,#{icu4c.opt_lib}" if OS.linux?

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    assert_match "Nuspell library loaded dictionary successfully.", shell_output("./test")
  end
end
