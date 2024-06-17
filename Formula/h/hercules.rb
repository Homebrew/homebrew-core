class Hercules < Formula
  desc "System/370, ESA/390 and z/Architecture Emulator"
  homepage "https://sdl-hercules-390.github.io/html/"
  url "https://github.com/SDL-Hercules-390/hyperion/archive/refs/tags/Release_4.7.tar.gz"
  sha256 "74c747773e0b5639164f6f69ce9220e1bd1d4853c5c4f18329da21c03aebe388"
  license "QPL-1.0"
  head "https://github.com/SDL-Hercules-390/hyperion.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "6335c4dd89a1abb2951183b3ec1b0b08fb67a31c40f037a79c55621670343f74"
    sha256 arm64_ventura:  "5329211fef90aff4b3eee6b92b28f00aec11d8d1c4de0f6b0fd3f785e735b64e"
    sha256 arm64_monterey: "4fc79b7305696102ac6f2adc908434782ab242b87594fcd018fb03beb5c39095"
    sha256 sonoma:         "01855e3533a3e48c482ba771afb025da4c822ad8813405597717487d7b8ffad6"
    sha256 ventura:        "6594a7b9c695403ca67c60f8408e66403a0b56169d87b038b3d7389e3368f43f"
    sha256 monterey:       "ca05b47ad3e18223fb77535ad13ec131767a631a71ab3de1d4cb3b146b4f34f0"
    sha256 x86_64_linux:   "7ef16d12587bb8a87a978599062d4fb6a8c23394da485664650e60234ef36c81"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "gnu-sed" => :build
  depends_on "libtool" => :build
  uses_from_macos "zlib"

  resource "crypto" do
    url "https://github.com/SDL-Hercules-390/crypto/archive/a5096e5dd79f46b568806240c0824cd8cb2fcda2.tar.gz"
    sha256 "78bda462d46c75ab4a92e7fd6755b648658851f5f1ac3f07423e55251bd83a8c"
  end

  resource "decNumber" do
    url "https://github.com/SDL-Hercules-390/decNumber/archive/3aa2f4531b5fcbd0478ecbaf72ccc47079c67280.tar.gz"
    sha256 "527192832f191454b19da953d1f3324c11a4f01770ad2451c42dc6d638baca62"
  end

  resource "SoftFloat" do
    url "https://github.com/SDL-Hercules-390/SoftFloat/archive/4b0c326008e174610969c92e69178939ed80653d.tar.gz"
    sha256 "46a141a183cb1ad8de937612d134ad51e8ff100931bcf6d4a62874baadf18e69"
  end

  resource "telnet" do
    url "https://github.com/SDL-Hercules-390/telnet/archive/729f0b688c1426018112c1e509f207fb5f266efa.tar.gz"
    sha256 "222bc9c5b56056b3fa4afdf4dd78ab1c87673c26c725309b1b3a6fd3e0e88d51"
  end

  def install
    resources.each do |r|
      resource_prefix = buildpath/r.name
      resource_prefix.rmtree
      build_dir = buildpath/"#{r.name}64.Release"

      r.stage do
        system "cmake", "-S", ".", "-B", build_dir, *std_cmake_args(install_prefix: resource_prefix)
        system "cmake", "--build", build_dir
        system "cmake", "--install", build_dir
      end

      (resource_prefix/"lib/aarch64").install_symlink (resource_prefix/"lib").children if Hardware::CPU.arm?
    end

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-optimization=no",
                          "--disable-getoptwrapper",
                          "--without-included-ltdl"
    system "make"
    ENV.deparallelize if OS.linux?
    system "make", "install"
    pkgshare.install "hercules.cnf"
  end

  test do
    (testpath/"test00.ctl").write <<~EOS
      TEST00 3390 10
      TEST.PDS EMPTY CYL 1 0 5 PO FB 80 6080
    EOS
    system "#{bin}/dasdload", "test00.ctl", "test00.ckd"
  end
end
