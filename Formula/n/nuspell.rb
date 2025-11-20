class Nuspell < Formula
  desc "Fast and safe spellchecking C++ library"
  homepage "https://nuspell.github.io/"
  url "https://github.com/nuspell/nuspell/archive/refs/tags/v5.1.6.tar.gz"
  sha256 "5d4baa1daf833a18dc06ae0af0571d9574cc849d47daff6b9ce11dac0a5ded6a"
  license "LGPL-3.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c3a95852340bbb21b54820e886e41d1fc2b4b8967fd96fe25e020f73d883c0d"
    sha256 cellar: :any,                 arm64_sequoia: "d7f6faea40e571722b97b290586074446559b554f7de96adc77158462197c84e"
    sha256 cellar: :any,                 arm64_sonoma:  "ab72aef2742998bb2bd3a6bad299c5a19fb43801477f524d6c64131afa154540"
    sha256 cellar: :any,                 sonoma:        "71f8a6c0ccef10c60ff7f12d7401e838957a7b6ce385df1e460fedcd4193bf2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbf11b8876a083a9a4310c855211fc3bca1a4b4517d5368f47986c96fe236037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f6fbc8698a0299c0801e29574333a1d7515365a901977f92e489f38b0f0f091"
  end

  depends_on "cmake" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :test
  depends_on "icu4c@78"

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
