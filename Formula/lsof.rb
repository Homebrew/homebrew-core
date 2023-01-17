class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://github.com/lsof-org/lsof"
  url "https://github.com/lsof-org/lsof/archive/refs/tags/4.97.0.tar.gz"
  sha256 "633fb6bdceb672bc09f8943ad54d4d105fff27caa728c775d9c3d08b147890cc"
  license "Zlib"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cc0913200a813f86945f75394e4e9ecde296f8912d472c89d3101412e1b382c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f886f81f7d3ed92535e42a56ec2156983120774782ae3a4e737d2a24c618e707"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd65ff2f77172bb550c210337c5b1d1d504218acb1f9f5cbd8b72f4092b318e3"
    sha256 cellar: :any_skip_relocation, ventura:        "d667f9432546a4e7a4e2e8bc31c820887a43b98721f520b355700ce7cb7601f3"
    sha256 cellar: :any_skip_relocation, monterey:       "b9c4d6e2f8a4e4c0d7bcd006bb0654a2e307854abef869bf18656d335569d8b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a64869d34df81c1aa1ba50707f2e2173c648962162008175e6433e97560b8620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9645696b4e94d5201f30920535b865f204566cef005f11948ff3494eae8aa789"
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
