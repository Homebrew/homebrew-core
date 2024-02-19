class Netperf < Formula
  desc "Benchmarks performance of many different types of networking"
  homepage "https://hewlettpackard.github.io/netperf/"

  stable do
    url "https://github.com/HewlettPackard/netperf/archive/refs/tags/netperf-2.7.0.tar.gz"
    sha256 "4569bafa4cca3d548eb96a486755af40bd9ceb6ab7c6abd81cc6aa4875007c4e"

    # only needed for AUTHORS changes of the following patch
    patch do
      url "https://github.com/HewlettPackard/netperf/commit/328fe3b56a8753f6f700aac2b2df84dda5ce93a3.patch?full_index=1"
      sha256 "e9696cb3dfccb73a595127c281ab0dd820eb8b84a440c96ab2c393444654daed"
    end

    patch do
      url "https://github.com/HewlettPackard/netperf/commit/0b0cbbef75021134c83be0c3dd21878467e11144.patch?full_index=1"
      sha256 "7dc26cd94228135f4f623a761bfd30e0e37076bf79d9a2e896ca63a5b56969cc"
    end

    # only needed for AUTHORS changes of the following patch
    patch do
      url "https://github.com/HewlettPackard/netperf/commit/ebc567aaad9b5d5808808c7d7aa78e80bb497e72.patch?full_index=1"
      sha256 "c16c4760e9b558fa3dfba95eabccabae5ee7775c610b917ad8c4d1d799119029"
    end

    patch do
      url "https://github.com/HewlettPackard/netperf/commit/40c8a0fb873ac07a95f0c0253b2bd66109aa4c51.patch?full_index=1"
      sha256 "072b24f7747d9e789422f0249be1023ee437628a8b5f56c3e27a5359daf55a92"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbb69e91e2bbb449c4b6ce47a4a3e624461262ed275327236afd7b83af588778"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76bf2f77ea0a7e854b9de5b139b4c8d6010a658aeace9a8bbe4691f26f4537e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa20dd669c5ea235a264c1684859a7c97e82bc3a5f210584ff17eb402ada2510"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb2e8ee85592d6dff9445af33d752ea5e73abb92fe690a7844e556059ba9e9f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "375c669d8ef5b9bfe11746f5ae7f1b41387648c6c746b9f81a3f49ab0b566edb"
    sha256 cellar: :any_skip_relocation, ventura:        "251f856fc4ffa7c7f5c5e0c865b1b5fa41d4f4cd25c213704c0e19657dcf67fb"
    sha256 cellar: :any_skip_relocation, monterey:       "c3418def36e0e68537fd927007c717c1d88fc604db1134125f36f7173f670bb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "de1b7e8643383ecc20cdd23742d2d7518dcb8bf49b77c98f32abed7dbca70f73"
    sha256 cellar: :any_skip_relocation, catalina:       "da28e83fa25e8284ee5acc7fa327d886bb53ab20035cd07703909b7556ab25e1"
    sha256 cellar: :any_skip_relocation, mojave:         "cdd840b5e300383245d703973fcd238d58b4bd89d2ae3ba6769db297b2ddb1f9"
    sha256 cellar: :any_skip_relocation, high_sierra:    "cf086e0d276a572aba8318f7080cedc94b36a7b612cdbb4bcc3ceefef0080c53"
    sha256 cellar: :any_skip_relocation, sierra:         "4d3f648081c84ad697d608b56bcfce3237de7c34c4e4a53d9851628f9d50cd5d"
    sha256 cellar: :any_skip_relocation, el_capitan:     "c6e96625b1f83a7f83d3c9b53b8584ab65d73cfd59bc38672588ba82d37ecc1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00d6096bef2a2982df63f66cb5400c568b0b917efe598b60bc4df5b54aa24e59"
  end

  head do
    url "https://github.com/HewlettPackard/netperf.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # (resolves "multiple definition of `...'" errors)
    ENV.append_to_cflags "-fcommon" if OS.linux?

    # https://github.com/HewlettPackard/netperf/pull/67
    inreplace "src/netcpu_osx.c", "/* #include <mach/mach_port.h> */", "#include <mach/mach_port.h>"
    inreplace "src/netcpu_osx.c", "mach_port_deallocate(lib_host_port)",
      "mach_port_deallocate(mach_task_self(), lib_host_port)"

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/netperf -h | cat"
  end
end
