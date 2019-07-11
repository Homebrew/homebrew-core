class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://people.freebsd.org/~abe/"
  url "https://github.com/lsof-org/lsof/archive/4.93.2.tar.gz"
  sha256 "3df912bd966fc24dc73ddea3e36a61d79270b21b085936a4caabca56e5b486a2"

  bottle do
    cellar :any_skip_relocation
    sha256 "830be0b158cbb5ff2f6bf019a517e6c89ff013760a6297fe8e285e66322b8e1a" => :mojave
    sha256 "276399b5b42f5a9dc167515add55c3bb2e545faec1299516b06793b1581a9311" => :high_sierra
    sha256 "9d57eea962770c2f3c5b56d26d9fdb9b0bbdde559dfc92d0c9db3dcaae33cc43" => :sierra
    sha256 "59c8c1a9455e3f10c8d6326bab49ab33a85c3cfa702627aa4ba2dd9600cc7d72" => :el_capitan
  end

  keg_only :provided_by_macos

  def install
    ENV["LSOF_INCLUDE"] = "#{MacOS.sdk_path}/usr/include"
    ENV["LSOF_CC"] = ENV.cc
    ENV["LSOF_CCV"] = ENV.cxx

    # Source hardcodes full header paths at /usr/include
    inreplace %w[
      dialects/darwin/kmem/dlsof.h
      dialects/darwin/kmem/machine.h
      dialects/darwin/libproc/machine.h
    ], "/usr/include", "#{MacOS.sdk_path}/usr/include"

    mv "00README", "README"
    system "./Configure", "-n", "darwin"

    system "make"
    bin.install "lsof"
    man8.install "lsof.8"
    prefix.install_metafiles
  end

  test do
    (testpath/"test").open("w") do
      system "#{bin}/lsof", testpath/"test"
    end
  end
end
