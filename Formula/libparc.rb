# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Libparc < Formula
  desc ""
  homepage ""
  url "https://github.com/FDio/cicn/archive/cframework/master.zip"
  version "1.0"
  sha256 "c49e1cbb4c534ca72109a1d53ce83e683e5bc7b30026e6c5eeefb0b9ef7df333"
  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    system "cmake", "libparc",
    "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test libparc`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
