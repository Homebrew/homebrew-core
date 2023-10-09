class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.11.3-Source.tar.gz"
  sha256 "66f4959e88b94dfecb7901a9370916bb57fa8b2cdaa2889099a907a706b655ec"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "9a07834d7fa1a5a06f1e8967e3c0b28882cc5f2f5b4be40ce22a19aca3e1a059"
    sha256                               arm64_ventura:  "47fdb3e2ea890d16dc84008f169461e25bab2067ddc59751db04191dc98bcfb1"
    sha256                               arm64_monterey: "3cf0b39c84a2e81a6f4b0cb940e0b6021cd4a519b3780c1b39772ca3f8305cc1"
    sha256                               arm64_big_sur:  "bfff4f201ed80d7ea06a59659e3129ee913b37c26d52f97d1c802ba12c364def"
    sha256                               sonoma:         "0aab913d360e7209d6f565aca50bada38ea8e92f672f4482cad14115fa4359ca"
    sha256                               ventura:        "7eccdbe7ae6a4d63554297a2eecb441be77bc16753a4a39d2e518a9a03c5feed"
    sha256                               monterey:       "1dc5e6bc1ba0752ac47fca7eaf3bb9e2cc3dbba7c1b3e55a748dfb9f9a904bc1"
    sha256                               big_sur:        "7e07b9f55a5ca7bdc7bd997d5bbc7e0a8406c04874af4b0c7786f50df4acf3ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8641681fdeb893419c7cc01315995c515720757588a288d10a2150f43eda1ea8"
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
