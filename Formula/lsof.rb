class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://github.com/lsof-org/lsof"
  url "https://github.com/lsof-org/lsof/archive/refs/tags/4.96.4.tar.gz"
  sha256 "b5a052cac8d6b2726bbb1de2b98c6d9204c7619263fb63e9b6b1bd6bbb37bf14"
  license "Zlib"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fb2e3da9b9598c9c13d2c2e3c7e9318719861d410c40427d534f7f1b4b234d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d50b920ac5d2c059e309f93666ef5820c6c056f6634478b480f260676c802c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bbe400a28a6a272a69a2cd3b1f60d79c962d5b20707aaa5d08acf1a18ebd1f1"
    sha256 cellar: :any_skip_relocation, ventura:        "69166cd5b18195924b1c1a894f6fa8869090aed44ce14d9e48cd2103e474c15d"
    sha256 cellar: :any_skip_relocation, monterey:       "0fd00244e8cf72fb1d5a0f73b2e080e4139d9053d0ab034a665d55f85f645dfd"
    sha256 cellar: :any_skip_relocation, big_sur:        "94cf1f76f879d90cd10f7fdd3811630058fca421ec49282efe59c08a8953ec89"
    sha256 cellar: :any_skip_relocation, catalina:       "afc0f2311f1666808d584e5919fe9708bfba27476b16263060a84adb5169d55e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92dbbee69d805b1db2b746e5859fe5cd4eccdda460d12b99988f5b9e28d66bec"
  end

  keg_only :provided_by_macos

  on_linux do
    depends_on "libtirpc"
  end

  def install
    if OS.mac?
      ENV["LSOF_INCLUDE"] = MacOS.sdk_path/"usr/include"

      # Source hardcodes full header paths at /usr/include
      inreplace %w[
        dialects/darwin/kmem/dlsof.h
        dialects/darwin/kmem/machine.h
        dialects/darwin/libproc/machine.h
      ], "/usr/include", MacOS.sdk_path/"usr/include"
    else
      ENV["LSOF_INCLUDE"] = HOMEBREW_PREFIX/"include"
    end

    ENV["LSOF_CC"] = ENV.cc
    ENV["LSOF_CCV"] = ENV.cxx

    mv "00README", "README"
    system "./Configure", "-n", OS.kernel_name.downcase

    system "make"
    bin.install "lsof"
    man8.install "Lsof.8"
  end

  test do
    (testpath/"test").open("w") do
      system "#{bin}/lsof", testpath/"test"
    end
  end
end
