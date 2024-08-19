class Nuspell < Formula
  desc "Fast and safe spellchecking C++ library"
  homepage "https://nuspell.github.io/"
  url "https://github.com/nuspell/nuspell/archive/refs/tags/v5.1.6.tar.gz"
  sha256 "5d4baa1daf833a18dc06ae0af0571d9574cc849d47daff6b9ce11dac0a5ded6a"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9e7281a57b83e677868aad16232d40fd48543ce65174f174bd443150c6361bb1"
    sha256 cellar: :any,                 arm64_ventura:  "6804f4fa88dbbd76f01aa90450346e0c00be89e3f4d732e2a2466976e84cbe58"
    sha256 cellar: :any,                 arm64_monterey: "c1596f60835c4dc02f005083b00a175505770fdd3333e868ac578a116cdcf92e"
    sha256 cellar: :any,                 sonoma:         "1ee2c3df9b096c680c09f3f80c138258e28bb10e122d15871e4e4a35f9702058"
    sha256 cellar: :any,                 ventura:        "fb64db7d781253262d6939f25c1c82745cabe55862696e025d469b8c151364c8"
    sha256 cellar: :any,                 monterey:       "b93489b214e38917fa7d11668421bf14f2f0d05cbca45c4a7e0e4f4b90360988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f682217bc55e204b2d6fb5911caad75c955fb28549195a0be5a7028d736526be"
  end

  depends_on "cmake" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :test
  depends_on "icu4c"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig"
    pkg_config_flags = shell_output("pkg-config --cflags --libs nuspell").chomp.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *pkg_config_flags
    assert_match "Nuspell library loaded dictionary successfully.", shell_output("./test")
  end
end
