# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Arturo < Formula
  desc "Simple, modern and powerful interpreted programming language for super-fast scripting."
  homepage "http://arturo-lang.io"
  url "https://github.com/arturo-lang/arturo/tarball/master"
  version "0.3.6"
  sha256 ""

  depends_on "bison" => :build
  depends_on "curl" => :build
  depends_on "dmd" => :build
  depends_on "dub" => :build
  depends_on "flex" => :build
  depends_on "gtk+" => :build

  def install
    system "dub build --build=release --compiler=dmd"
    bin.install "arturo"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test Arturo`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
