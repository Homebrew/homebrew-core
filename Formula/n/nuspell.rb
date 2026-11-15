class Nuspell < Formula
  desc "Fast and safe spellchecking C++ library"
  homepage "https://nuspell.github.io/"
  url "https://github.com/nuspell/nuspell/archive/refs/tags/v5.1.9.tar.gz"
  sha256 "658a28d2c622b6da5271544043a5b7b3e09881be8516a23efc11c43971b4b046"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "6ce5bc25046ec320f50c92381b0a5281acac6065ac4464d7b4f508b4c4fa78c7"
    sha256 cellar: :any, arm64_tahoe:       "98356bfbd20766ee9c159949bfa28406842f35845533d5f0c967c4686e2fb1f3"
    sha256 cellar: :any, arm64_sequoia:     "03ff40e178ddeab40c63f112ff0195bcea199de886b85d0321f19e364be53612"
    sha256 cellar: :any, arm64_linux:       "f74a91a92da4b11bb8cff11b913fce633a81909581b19bccf93d6ceca9ecdecd"
    sha256 cellar: :any, x86_64_linux:      "ae6971d94579600eb7735f510e7059c7f7975bab497d335e8820597c79f49237"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :test
  depends_on "icu4c@79"

  deny_network_access!

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
      INFO: Input encoding=UTF-8, Output encoding=UTF-8
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
