class Libfyaml < Formula
  desc "Fully feature complete YAML parser and emitter"
  homepage "https://github.com/pantoniou/libfyaml"
  url "https://github.com/pantoniou/libfyaml/releases/download/v0.9.4/libfyaml-0.9.4.tar.gz"
  sha256 "dac2b0af7b757b32a4fa7c6493d85d0f7dea6effd20ae4352570b6a450b9e5fb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5fab9ef2a5b35ceaaa66ae9651d5b360b61f11785c3f501bcbe4eeef94d0fbe9"
    sha256 cellar: :any,                 arm64_sequoia: "ffbae1db72dca752e9c4101cac7c98eb6ce9519bfcb07a1d6a85af536ae64c78"
    sha256 cellar: :any,                 arm64_sonoma:  "3fb3558cc25558c914181ad7a69a715a429aa91d3500a2e9df9b7655f7952024"
    sha256 cellar: :any,                 sonoma:        "dab4726be4d9ec849dae8f8199cbafe93f50b89d238b2df612d01ad72a259a54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52adfa81a7599fa7b76eb853727084b7f6e9147590efd944a18c90fc4a41e0dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3c68885b9453639f731e261c39c8a04d6cfe8b150efb311635ce7cb10e30462"
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
