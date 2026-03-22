class Nuspell < Formula
  desc "Fast and safe spellchecking C++ library"
  homepage "https://nuspell.github.io/"
  url "https://github.com/nuspell/nuspell/archive/refs/tags/v5.1.7.tar.gz"
  sha256 "9aee944e86924ce44434741cb950fee8f9a6ff9c4f002803ab5f04698c8e4c68"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6863e34c58596b85e558b7184ac455bf449ff65cd5b9ac2f3d3f4c509ca155a6"
    sha256 cellar: :any,                 arm64_sequoia: "d28b1a84a1ec0cfd557fcf6febd53a6c0cf1fd10fb4363ddb7566518b5cd7ea6"
    sha256 cellar: :any,                 arm64_sonoma:  "5462266d572558109b691dd064870f1bbeb1a7e6b7d455c8c6a7cd7cabf319e4"
    sha256 cellar: :any,                 sonoma:        "38a0d023c75e8bb42cf442000fcf1e652517dbac3ad292d744a0f405e77e30ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d32911d3302e34fc0d672550c67d524070c0313b29f2f8177154644eff4402c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f038716f553adbecc58cf191544f5cca27c9bdcdc0e79f8c380e66a13f1a34e"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
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
