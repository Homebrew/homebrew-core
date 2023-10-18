class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.11.4-Source.tar.gz"
  sha256 "4836a876277c9a65a47a3dc87cae116c3009699f8a25bab4e3afabf160bcf212"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "1a121595a6400b918596dc7e8cf3de5b3fd0f1b884ee665fc6ed6edae8eac8ea"
    sha256                               arm64_ventura:  "433514a4337a239d95622a63e0238e4e0d15bbdb0af27736aad2df7ae0ea2d1a"
    sha256                               arm64_monterey: "c241c4c06635ef7f7ff3d4d65d91efdc5e79b1ec56acfd9c2a07e741cd9c29db"
    sha256                               sonoma:         "2b6d739250675e59a1c7ed6ff60ec868acf9c682dfd0db2e9dad47ccfca4005a"
    sha256                               ventura:        "66b1e480c3f35afc5800f8abb150031258847e06fc0ab38b3eef80fff05e9826"
    sha256                               monterey:       "cf6b9ca09de87a706585bcd40802e4ece4cc0d9ea6e0b93b32d34fca369136a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c53d3d60d8d2fe3df9cda45da950598fad76f992d3a81a8e1d90bbe058a9ed6"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "qt"

  # requires C++17 compiler to build with Qt
  fails_with gcc: "5"

  # Fixes a typo in upstream's code. Remove once merged and released.
  # PR ref: https://github.com/ecmwf/ecflow/pull/35
  patch do
    url "https://github.com/ecmwf/ecflow/commit/5bf5f8490f3ba0a39c9119ba03f8a9b349f6c3ec.patch?full_index=1"
    sha256 "747e7d8bfb84e3e60c7775a58607bdbf666d83b9c3cc544dc79bbf9ff3e2922b"
  end

  def install
    mkdir "build" do
      system "cmake", "..",
                      "-DENABLE_SSL=1",
                      "-DENABLE_PYTHON=OFF",
                      "-DECBUILD_LOG_LEVEL=DEBUG",
                      "-DENABLE_SERVER=OFF",
                      *std_cmake_args
      system "make", "install"
    end
  end

  # current tests assume the existence of ecflow_client, but we may not always supply
  # this in future versions, but for now it's the best test we can do to make sure things
  # are linked properly
  test do
    # check that the binary runs and that it can read its config and picks up the
    # correct version number from it
    binary_version_out = shell_output("#{bin}/ecflow_ui.x --version")
    assert_match @version.to_s, binary_version_out

    #  check that the startup script runs
    system "#{bin}/ecflow_ui", "-h"
    help_out = shell_output("#{bin}/ecflow_ui -h")
    assert_match "ecFlowUI", help_out
    assert_match "fontsize", help_out
    assert_match "start with the specified configuration directory", help_out
  end
end
