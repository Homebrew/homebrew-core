class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://people.freebsd.org/~abe/"
  url "https://github.com/lsof-org/lsof/archive/4.93.2.tar.gz"
  sha256 "3df912bd966fc24dc73ddea3e36a61d79270b21b085936a4caabca56e5b486a2"

  bottle do
    cellar :any_skip_relocation
    sha256 "3532e9650fc5b836d5584cd8733f83218229d170859bf2c85e62b4abad08d356" => :mojave
    sha256 "8ebe4f68ada3d1c1984bbfb660437984f5fc9d61c93b3da8024bfd0d797a2172" => :high_sierra
    sha256 "e07f28fd45b1eae5231393b45360920da4ad4386a83ccb6a256fc7ea26509f59" => :sierra
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
