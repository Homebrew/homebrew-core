# Documentation: http://docs.brew.sh/Formula-Cookbook.html
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Httpflow < Formula
  desc "Packet capture and analysis utility similar to tcpdump for HTTP Edit"
  homepage "https://github.com/six-ddc/httpflow/releases"
  url "https://github.com/six-ddc/httpflow/archive/0.0.3.tar.gz"
  sha256 "26e8d1f8d6c0742b552bc333edd340dc3b3e3ad4590fe2e0e125d830142f0b37"
  head "https://github.com/six-ddc/httpflow.git", :branch => "master"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    args = %W[
      PREFIX=#{prefix}
      CXX=#{ENV.cxx}
    ]


    # Remove unrecognized options if warned by configure
    system "make"
    system "make", "install", *args
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test httpflow`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "#{bin}/httpflow", "-h"
  end
end
