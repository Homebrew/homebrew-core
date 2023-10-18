class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://www.actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.19.4.tar.gz"
  sha256 "114d43e3a7a2305ca1d2106cd0daeff471564f62b90db1e453ba9eb5c47c02f6"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d0a8d3c6b13d2d74323eac03e6c53ac2341b14e093ac8f16a5aa1a3160cd5f2d"
    sha256 cellar: :any,                 arm64_ventura:  "f902f4443c42ce292434c5d30e07f31e588811143a33af8a0d4ef9f05505ded3"
    sha256 cellar: :any,                 arm64_monterey: "27411eccf8a105b81b60321d32da20cbd8d2955439bdcca6c7fd9129a9a26681"
    sha256 cellar: :any,                 sonoma:         "43714888a753c5fda49a62d340466847892eb831edeccacd052f6ac9e9c8082d"
    sha256 cellar: :any,                 ventura:        "27f6c2f27d9a009064d704385e7f0c1275c2e1e8768705d183131fd2f7298bfd"
    sha256 cellar: :any,                 monterey:       "8fb5bf6eaf47907b13488509ac7c5ecbb8f93d59276375457c9cd0cc91318d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf0708e0ba9fd0f6c117fd350be06faeaab0ed3f0e26dce435919a95164a7c69"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  fails_with gcc: "5"

  def install
    tools = pkgshare/"tools"
    rpaths = [rpath, rpath(source: tools)]
    args = ["-DCAF_ENABLE_TESTING=OFF", "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}"]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <caf/all.hpp>
      using namespace caf;
      void caf_main(actor_system& system) {
        scoped_actor self{system};
        self->spawn([] {
          std::cout << "test" << std::endl;
        });
      }
      CAF_MAIN()
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lcaf_core", "-o", "test"
    system "./test"
  end
end
