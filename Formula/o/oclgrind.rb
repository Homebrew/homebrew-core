class Oclgrind < Formula
  desc "OpenCL device simulator and debugger"
  homepage "https://github.com/jrprice/Oclgrind"
  url "https://github.com/jrprice/Oclgrind/archive/refs/tags/v21.10.tar.gz"
  sha256 "b40ea81fcf64e9012d63c3128640fde9785ef4f304f9f876f53496595b8e62cc"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "5125b9afb6956eca58806399252680b2e90a085bdffb3fa4549245f3549be711"
    sha256 cellar: :any,                 arm64_sequoia: "c01a0c14afb634bcd2ccd552bb958484b447101e106bcbe13f86b2d7c207e69c"
    sha256 cellar: :any,                 arm64_sonoma:  "8f2733e4d37f63d59c26e494e777cf2ac0b4c7d70282c86a7c1715e6a0f94e0b"
    sha256 cellar: :any,                 sonoma:        "925f7da504e7ea5a8778d2074c75f6931ff435e528643c25f165212587233a63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15e5413070e0711c302d2493d34b3c37d03ed3ab84eedc212099e4fcaa5fbde4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70b8d27cfcae4a9a284637525781d1c6c7b61b7236bfb94142341453af3f3fa5"
  end

  depends_on "cmake" => :build
  depends_on "llvm@19" # Issue for LLVM 20: https://github.com/jrprice/Oclgrind/issues/216
  depends_on "readline"

  on_linux do
    depends_on "opencl-headers" => :test
  end

  # Backport support for `llvm@14`. Remove in the next release.
  patch do
    url "https://github.com/jrprice/Oclgrind/commit/6c76e7bec0aa7fa451515a5cfcb35ab2384ba6e0.patch?full_index=1"
    sha256 "8c1b8ec75d8d8c8d02246124b40452ec9ef1243d3e3c497fe4ffa8571cd98ade"
  end

  # Backport CI/test changes to apply later commits
  patch do
    url "https://github.com/jrprice/Oclgrind/commit/92da61bbe773db2b36037ea97563750065696d10.patch?full_index=1"
    sha256 "5f40561f7beb8bad5b665a52332ff865cdaf00296e56e467e11de69fa71a82b2"
  end
  patch do
    url "https://github.com/jrprice/Oclgrind/commit/b8dea2756cee3cad61e00bd4f7572ab00ccf44bc.patch?full_index=1"
    sha256 "d2c4674bc3a355695a9f27c0fb8967c288c93638e5ed7be1cc55148606e5eed3"
  end
  patch do
    url "https://github.com/jrprice/Oclgrind/commit/7e0613dac7a585699c66043104fda401dd0234ed.patch?full_index=1"
    sha256 "403b734a5cd71b245d057bb57e1573a2c77225716d55c7d90d3a9a20f801d5ca"
  end
  patch do
    url "https://github.com/jrprice/Oclgrind/commit/accf518f8623548417c344a0193aa9b531cc9486.patch?full_index=1"
    sha256 "7f0f1e1c5a61109e09cd108be8cebef81392c1815903decd3c41e3d75a71d972"
  end
  patch do
    url "https://github.com/jrprice/Oclgrind/commit/9957047931bb9c7e2aa38c8687b6eb54a88fb4b8.patch?full_index=1"
    sha256 "83be80b8052b582fc1019f8820c48d8e83c0b14d6c6b4b9d7bdffb912aaae771"
  end
  patch do
    url "https://github.com/jrprice/Oclgrind/commit/8c41dc9d44716850dd8202d5c465dad6978491f9.patch?full_index=1"
    sha256 "a87bf982c1b089d623e8a94f4c6dd57c5bd23e6f30e8563011a02254100146ae"
  end
  patch do
    url "https://github.com/jrprice/Oclgrind/commit/6d64783add2a15c6633c52f84b6d4228048c676d.patch?full_index=1"
    sha256 "7a8d64d60c9c891bd0bf74b145ccdee6067c473d7387768028da893d7f8dc308"
  end

  # Backport support for LLVM 15
  patch do
    url "https://github.com/jrprice/Oclgrind/commit/265d7fa8d8db2b64e2812bf529bfc0aa7bdd9734.patch?full_index=1"
    sha256 "567dd21a5f30eaf31b18fd212f277783b7268b64a9761947b4f562b9a7bb1c5c"
  end
  patch do
    url "https://github.com/jrprice/Oclgrind/commit/9fbb8b2583f7005f65f787ba4b1e950e03f606d8.patch?full_index=1"
    sha256 "0f530d49acc07ba6f9be2626f8aeaff3b31958bf1919fce9eafac0b04ad6ca2c"
  end

  # Backport support for LLVM 16
  patch do
    url "https://github.com/jrprice/Oclgrind/commit/53ed0f7f489371a2721bfe05d28153f0f61db61f.patch?full_index=1"
    sha256 "c9726ed3154b3a208bc987fbb8a09c1c19d17220c7508e9eadba5fdd81c13213"
  end

  # Backport support for LLVM 17
  patch do
    url "https://github.com/jrprice/Oclgrind/commit/2af59d53a98633040884bb2ae34de0755d229556.patch?full_index=1"
    sha256 "ffba84f069b478c3c40435481d101228f8c60ef542070d42ed0a76412f59f9e6"
  end

  # Backport support for LLVM 18
  patch do
    url "https://github.com/jrprice/Oclgrind/commit/6f9bd9aee73d796d18af1f77689b4c1eb05ead02.patch?full_index=1"
    sha256 "adf85b1adcd951eb82c263619b999a860166a35cbf8a68cc7d7e1b35eb217894"
  end

  # Backport support for LLVM 19
  patch do
    url "https://github.com/jrprice/Oclgrind/commit/7cc48c424a65dfb870b1e7614b59362dff44b348.patch?full_index=1"
    sha256 "3727836bbc42691bbb34fdd16a266586e01de8ee68b948e9a43fbea10977d864"
  end

  def install
    llvm = deps.find { |dep| dep.name.match?(/^llvm(@\d+)?$/) }
               .to_formula
    rpaths = [rpath, rpath(target: llvm.opt_lib)]
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    # Install the optional ICD into #{prefix}/etc rather than #{etc} as it contains realpath
    # to the shared library and needs to be kept up-to-date to work with an ICD loader.
    # This relies on `brew link` automatically creating and updating #{etc} symlinks.
    (prefix/"etc/OpenCL/vendors").install "build/oclgrind.icd"
  end

  test do
    (testpath/"rot13.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <string.h>
      #include <#{OS.mac? ? "OpenCL" : "CL"}/cl.h>

      const char rot13_cl[] = "                         \\
      __kernel void rot13                               \\
          (   __global    const   char*    in           \\
          ,   __global            char*    out          \\
          )                                             \\
      {                                                 \\
          const uint index = get_global_id(0);          \\
                                                        \\
          char c=in[index];                             \\
          if (c<'A' || c>'z' || (c>'Z' && c<'a')) {     \\
              out[index] = in[index];                   \\
          } else {                                      \\
              if (c>'m' || (c>'M' && c<'a')) {          \\
                out[index] = in[index]-13;              \\
              } else {                                  \\
                out[index] = in[index]+13;              \\
              }                                         \\
          }                                             \\
      }                                                 \\
      ";

      void rot13 (char *buf) {
        int index=0;
        char c=buf[index];
        while (c!=0) {
          if (c<'A' || c>'z' || (c>'Z' && c<'a')) {
            buf[index] = buf[index];
          } else {
            if (c>'m' || (c>'M' && c<'a')) {
              buf[index] = buf[index]-13;
            } else {
              buf[index] = buf[index]+13;
            }
          }
          c=buf[++index];
        }
      }

      int main() {
        char buf[]="Hello, World!";
        size_t srcsize, worksize=strlen(buf);

        cl_int error;
        cl_platform_id platform;
        cl_device_id device;
        cl_uint platforms, devices;

        error=clGetPlatformIDs(1, &platform, &platforms);
        error=clGetDeviceIDs(platform, CL_DEVICE_TYPE_ALL, 1, &device, &devices);
        cl_context_properties properties[]={
                CL_CONTEXT_PLATFORM, (cl_context_properties)platform,
                0};

        cl_context context=clCreateContext(properties, 1, &device, NULL, NULL, &error);
        cl_command_queue cq = clCreateCommandQueue(context, device, 0, &error);

        rot13(buf);

        const char *src=rot13_cl;
        srcsize=strlen(rot13_cl);

        const char *srcptr[]={src};
        cl_program prog=clCreateProgramWithSource(context,
                1, srcptr, &srcsize, &error);
        error=clBuildProgram(prog, 0, NULL, "", NULL, NULL);

        if (error == CL_BUILD_PROGRAM_FAILURE) {
          size_t logsize;
          clGetProgramBuildInfo(prog, device, CL_PROGRAM_BUILD_LOG, 0, NULL, &logsize);

          char *log=(char *)malloc(logsize);
          clGetProgramBuildInfo(prog, device, CL_PROGRAM_BUILD_LOG, logsize, log, NULL);

          fprintf(stderr, "%s\\n", log);
          free(log);

          return 1;
        }

        cl_mem mem1, mem2;
        mem1=clCreateBuffer(context, CL_MEM_READ_ONLY, worksize, NULL, &error);
        mem2=clCreateBuffer(context, CL_MEM_WRITE_ONLY, worksize, NULL, &error);

        cl_kernel k_rot13=clCreateKernel(prog, "rot13", &error);
        clSetKernelArg(k_rot13, 0, sizeof(mem1), &mem1);
        clSetKernelArg(k_rot13, 1, sizeof(mem2), &mem2);

        char buf2[sizeof buf];
        buf2[0]='?';
        buf2[worksize]=0;

        error=clEnqueueWriteBuffer(cq, mem1, CL_FALSE, 0, worksize, buf, 0, NULL, NULL);
        error=clEnqueueNDRangeKernel(cq, k_rot13, 1, NULL, &worksize, &worksize, 0, NULL, NULL);
        error=clEnqueueReadBuffer(cq, mem2, CL_FALSE, 0, worksize, buf2, 0, NULL, NULL);
        error=clFinish(cq);

        puts(buf2);
      }
    C

    system ENV.cc, "rot13.c", "-o", "rot13", "-L#{lib}", "-loclgrind-rt"
    output = shell_output("#{bin}/oclgrind ./rot13 2>&1").chomp
    assert_equal "Hello, World!", output
  end
end
