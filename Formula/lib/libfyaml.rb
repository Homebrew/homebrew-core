class Libfyaml < Formula
  desc "Fully feature complete YAML parser and emitter"
  homepage "https://github.com/pantoniou/libfyaml"
  url "https://github.com/pantoniou/libfyaml/releases/download/v0.9.6/libfyaml-0.9.6.tar.gz"
  sha256 "a59cc3331e2eb903ec36933ad52a45888041cac31e44f553a00511131242c483"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "50fb30d6db3da0bbda7d36d346e78bf30a82a13b9ed263661ab679f9fab2e2a5"
    sha256 cellar: :any,                 arm64_sequoia: "0ecf0978f6f3abc4197219df6e0516cae6fb70224140194e8431233a5d46c661"
    sha256 cellar: :any,                 arm64_sonoma:  "27587d70e74d903bcd0d43a2632c18a69c4d0a585dd8de4f7d6423e97bff694c"
    sha256 cellar: :any,                 sonoma:        "6bb2bf4968461df7d2469cbab44074a2c7b3f39b2c39aea1de741b7550e1cfeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dc2fcfb912ad0a464b48f0e6674416d627591c06882ee61f45134c548341687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df9c7be47669e502ab428f136732a9200c344ef8b56d390bafec34fc1151e71d"
  end

  uses_from_macos "m4" => :build

  # TODO: Remove patch when https://github.com/pantoniou/libfyaml/pull/267 is merged
  patch do
    url "https://github.com/pantoniou/libfyaml/commit/45faa819b6c3eb54b2d63b46d4c7690fa1e8e8ff.patch?full_index=1"
    sha256 "22fbbb360b96cf879397f1ab3dadf8876277f8d77708b6252c0908d37e09a4f9"
  end

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
