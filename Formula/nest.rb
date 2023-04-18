class Nest < Formula
  desc "Neural Simulation Tool (NEST) with Python3 bindings (PyNEST)"
  homepage "https://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/archive/v3.4.tar.gz"
  sha256 "c56699111f899045ba48e55e87d14eca8763b48ebbb3648beee701a36aa3af20"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "fc93f6246137d84c772a77aed2745693dc36c593f89bc5736386ec5ac382c453"
    sha256 arm64_monterey: "3b4d7bb1aa43efeb5f168668e6c4304476e738dd00e6e2575ecc4c9ec8420357"
    sha256 arm64_big_sur:  "ed824604ce01c87ef555cc0ce71d923e9f53c236e8f356ffe77b916cc52b65e8"
    sha256 ventura:        "4d89f6810fa548716be37e5cf41242435e5d187f6041f6cc4f95db541dc9d28b"
    sha256 monterey:       "04b8bd41ba16be78537d33b6d4e8d3b45ec2852b250c07da70f1837b9405926d"
    sha256 big_sur:        "9a59224bedeb71ec0febab939414fd82105a26c5e74ca83e12272c5061961f98"
    sha256 x86_64_linux:   "5fab36854a9a878c85e4c8011312b18cd531d07c53437e6a126641fb41489824"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "gsl"
  depends_on "libtool"
  depends_on "numpy"
  depends_on "python@3.11"
  depends_on "readline"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "libomp"
  end

  def install
    # Help FindReadline find macOS system ncurses library
    sdk = MacOS.sdk_path_if_needed
    args = sdk ? ["-DNCURSES_LIBRARY=#{sdk}/usr/lib/libncurses.tbd"] : []

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Replace internally accessible gcc with externally accessible version
    # in nest-config if required
    inreplace bin/"nest-config", Superenv.shims_path/ENV.cxx, ENV.cxx
  end

  def caveats
    <<~EOS
      The PyNEST bindings and its dependencies are installed with the python@3.11 formula.
      If you want to use PyNEST, use the Python interpreter from this path:

          #{Formula["python@3.11"].bin}

      You may want to add this to your PATH.
    EOS
  end

  test do
    # check whether NEST was compiled & linked
    system bin/"nest", "--version"

    # check whether NEST is importable form python
    system Formula["python@3.11"].bin/"python3.11", "-c", "'import nest'"
  end
end
