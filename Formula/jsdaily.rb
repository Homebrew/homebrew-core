# Documentation: https://docs.brew.sh/Formula-Cookbook
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Jsdaily < Formula
  include Language::Python::Virtualenv

  desc "Some useful daily utility scripts."
  homepage "https://github.com/JarryShaw/jsdaily#jsdaily"
  url "https://github.com/JarryShaw/jsdaily/archive/v1.1.1.tar.gz"
  sha256 "cfb4c0c695b5cffbabc5a579b206822bb713a6f4aadcce0adfb964bf5c2ccbf2"
  head "https://github.com/JarryShaw/jsdaily.git", :branch => "master"
  # depends_on "cmake" => :build
  depends_on "python"

  def install
  #   # ENV.deparallelize  # if your formula fails when building in parallel
  #   # Remove unrecognized options if warned by configure
  #   system "./configure", "--disable-debug",
  #                         "--disable-dependency-tracking",
  #                         "--disable-silent-rules",
  #                         "--prefix=#{prefix}"
  #   # system "cmake", ".", *std_cmake_args
  #   system "make", "install" # if this fails, try separate make/make install steps
      virtualenv_install_with_resources
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test jsdaily`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    # system "false"
    system bin/"jsdaily", "update", "--all"
  end
end
