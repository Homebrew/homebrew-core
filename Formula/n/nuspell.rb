class Nuspell < Formula
  desc "Fast and safe spellchecking C++ library"
  homepage "https://nuspell.github.io/"
  url "https://github.com/nuspell/nuspell/archive/refs/tags/v5.1.6.tar.gz"
  sha256 "5d4baa1daf833a18dc06ae0af0571d9574cc849d47daff6b9ce11dac0a5ded6a"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3b957ee134c236462ecffd48f31b6099a881359cad7f3d104c458389a9080de3"
    sha256 cellar: :any,                 arm64_sonoma:  "a0cc74c79b30f86b3e20a90a6f6abd75c9d5c048ecfa8be58000e961e6260701"
    sha256 cellar: :any,                 arm64_ventura: "a475126aa1ef8141f7acfed5cf7d6bf94b854675e5680dc28455c121e97225ca"
    sha256 cellar: :any,                 sonoma:        "9d73cd5176f879c4d2ba855b879b005888b7f501f02dba868915a09e01ceb968"
    sha256 cellar: :any,                 ventura:       "e4236a6e4cb09f6fd4957a089f929e5c3475c70878698e5a6bfb7fc33e33ce72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a61b3f7e409ed97a7610dd2796e98e5b40eaac9df9883c6efe4ed2a7c6c0d1b"
  end

  depends_on "cmake" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :test
  depends_on "icu4c@75"

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

    (testpath/"test.cpp").write <<~EOS
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
    EOS

    icu4c = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                .to_formula
    ENV.prepend_path "PKG_CONFIG_PATH", icu4c.opt_lib/"pkgconfig"
    flags = shell_output("pkg-config --cflags --libs nuspell").chomp.split
    flags << "-Wl,-rpath,#{lib},-rpath,#{icu4c.opt_lib}" if OS.linux?

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    assert_match "Nuspell library loaded dictionary successfully.", shell_output("./test")
  end
end
