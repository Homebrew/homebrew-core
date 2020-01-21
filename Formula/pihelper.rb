class Pihelper < Formula
  desc "Unofficial command-line client for the Pi-hole"
  homepage "https://git.wbrawner.com/cgit.cgi/Pi-Helper/pihelper.git/about/"
  url "https://git.wbrawner.com/cgit.cgi/Pi-Helper/pihelper.git/snapshot/pihelper-0.1.0.tar.gz"
  sha256 "110f16e1e8167c18ce7c11fd5a8d73f016f0e5a9c4e5898f3b24bbdd878bafcb"

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "openssl@1.1"
  uses_from_macos "curl"

  def install
    system "cmake", ".", "-DPIHELPER_EXECUTABLE=ON", "-DPIHELPER_STATIC=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    require "open3"
    File.write(Dir.pwd + "/tmp_file", "host=localhost\napi-key=test\n")
    Open3.popen3("#{bin}/pihelper", "-f", Dir.pwd + "/tmp_file") do |_, _, stderr|
      assert_equal "Failed to retrieve status for Pi-hole at localhost\n" + "\n", stderr.read
    end
  end
end
