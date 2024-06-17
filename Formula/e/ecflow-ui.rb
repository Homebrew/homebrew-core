class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.12.4-Source.tar.gz"
  sha256 "4ff11e420105ffcff6fa2f9d54682ac9e7f0007b6a7c52d1ce3cd6cd81cebfe5"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "5c71db0459761beb117b355596bcb66a345893c2aeeba73886a63a5bbd2cf04f"
    sha256                               arm64_ventura:  "bdbfe935e374dc09d61dca65993cd5967ec6c7cbf410c0874acf41c70753d777"
    sha256                               arm64_monterey: "ae039fe42842b6ce5716a1eac670770b3c0c85c95e7c229705f6eb0698d5b3c4"
    sha256                               sonoma:         "11a6f7822a8508a2a3c9c886c1d4f950f11ec862fb3d684a5ceb0fc0010a7503"
    sha256                               ventura:        "dd10290cdbdcd97a5fefa09e1617af0da806fa4ad009c20bb673e9fc1e721c71"
    sha256                               monterey:       "850b7ad610597da55e483dd7783b40d8b72fcb9664583045506a36885ab87635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd4766f7d3b50abde37bbe2fcbfb153183737b912b26bcbec4722b5a8842287c"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "qt"

  # requires C++17 compiler to build with Qt
  fails_with gcc: "5"

  def install
    args = %w[
      -DECBUILD_LOG_LEVEL=DEBUG
      -DENABLE_PYTHON=OFF
      -DENABLE_SERVER=OFF
      -DENABLE_SSL=1
      -DENABLE_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
