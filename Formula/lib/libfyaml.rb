class Libfyaml < Formula
  desc "Fully feature complete YAML parser and emitter"
  homepage "https://github.com/pantoniou/libfyaml"
  url "https://github.com/pantoniou/libfyaml/releases/download/v0.9/libfyaml-0.9.tar.gz"
  sha256 "7731edc5dfcc345d5c5c9f6ce597133991a689dabede393cd77bae89b327cd6d"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "2af9a61ac94f34469841b23e4fd9c82049b46225c6acc7580f6a9703acec3750"
    sha256 cellar: :any,                 arm64_sequoia:  "4296a8c80863d912ba93d237d0635b4b6568dfaec713cd69d5424ea77ad4097e"
    sha256 cellar: :any,                 arm64_sonoma:   "f048b398ea675ff84cffed39be72aad7aebc2ff7b343291e82982e1d8aa299bc"
    sha256 cellar: :any,                 arm64_ventura:  "7e0abdbb0374744a92305e607e3fccee6ba6bc09f01906719ec91b721a7176a8"
    sha256 cellar: :any,                 arm64_monterey: "a4b6daf2e59d3361a9eeda457e5964672ecba38d7126c731684aec495db5bd2c"
    sha256 cellar: :any,                 sonoma:         "6758d7c2b7667096e19a1b6f5a41b072fe34aafda17650fc873b781eeebc7211"
    sha256 cellar: :any,                 ventura:        "24121cefb2cdd277652bfc857f9fd2b01042769aeeb9a622aba142e978ba99c0"
    sha256 cellar: :any,                 monterey:       "4730aa6a64ffd960a0d82cbcc69734ffddb7abf29ae27450dfed7fc818a17935"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d657e265f72bf3f8704c2d903d419ecbf89ad79803c4b67563e619733530117d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e4efc82a84ba883c56fe0ee85008a68a91863460ae0eae5dc02952143c8983d"
  end

  uses_from_macos "m4" => :build

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #ifdef HAVE_CONFIG_H
      #include "config.h"
      #endif

      #include <iostream>
      #include <libfyaml.h>

      int main(int argc, char *argv[])
      {
        std::cout << fy_library_version() << std::endl;
        return EXIT_SUCCESS;
      }
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lfyaml", "-o", "test"
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_equal version.to_s, shell_output("#{testpath}/test").strip
    assert_equal version.to_s, shell_output("#{bin}/fy-tool --version").strip
  end
end
