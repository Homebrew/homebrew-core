class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.10.0-Source.tar.gz"
  sha256 "835b50540fbda7c0a375e1d5bc9d1c51fe229412ba2178682c4cd52e9573043c"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "061d4e267e0345e24396cbff4f77a400bd4f867bc60a468a0ec7087025ccdf78"
    sha256                               arm64_monterey: "2f1a0b96cdea40d0164b44d818926f0b30e5c24887b0956ffa6b421aab10bdf6"
    sha256                               arm64_big_sur:  "47605078dea0a074fc172a151da37a33b8f706e17a20ef6a3737230a5de71c63"
    sha256                               ventura:        "c7809eb583525d00d133d1a5fb1189d29fd6d5202ad741860146429bd7fbbbf1"
    sha256                               monterey:       "d1d24bb5315fde008529632fbe9545f57610eedcfda266dfc80dbf1b20cf8038"
    sha256                               big_sur:        "ce1ec92503f63ad7f90b0c2234dd86fba0e672a5d23826bd62e848bac2341a7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "543e0c2957fc2ac582f7bf8ebd814a8bf46256c270635501e43506e19470a21a"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@1.1"
  depends_on "qt"

  # requires C++17 compiler to build with Qt
  fails_with gcc: "5"

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
    assert_match "start with the specified configuraton directory", help_out
  end
end
