class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.8.1-Source.tar.gz"
  sha256 "be2ff0b76da2917a00ba13cd02b2992616e374b102ea92dff63a022fbdaa1884"
  license "Apache-2.0"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "openssl@1.1"
  depends_on "qt"

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
    system "#{bin}/ecflow_client", "--help"
    help_out = shell_output("#{bin}/ecflow_client", "--help")
    assert_match "Ecflow version", help_out
    assert_match "ecflow_client", help_out
    assert_match "begin", help_out
    assert_match "zombie_get", help_out
  end
end
