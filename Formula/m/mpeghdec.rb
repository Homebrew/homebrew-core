class Mpeghdec < Formula
  desc "Fraunhofer MPEG-H decoder (mpeghdec)"
  homepage "https://www.mpegh.com"
  url "https://github.com/Fraunhofer-IIS/mpeghdec/archive/refs/tags/r4.0.1.tar.gz"
  sha256 "e7842b46c8054367eea0537922b61180be7e7dc9747d872071854b08139c6016"
  license :cannot_represent # Fraunhofer FDK MPEG-H Software License
  head "https://github.com/Fraunhofer-IIS/mpeghdec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^r?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  resource "ilo" do
    url "https://github.com/Fraunhofer-IIS/ilo/archive/refs/tags/r2.0.2.tar.gz"
    sha256 "2f0e57652e5c028f0fc5cfe640c7fe652635db9796a19835d786ccd09a227b2d"

    livecheck do
      url "https://github.com/Fraunhofer-IIS/ilo"
      regex(/^r?(\d+(?:\.\d+)+)$/i)
    end
  end

  resource "mmtisobmff" do
    url "https://github.com/Fraunhofer-IIS/mmtisobmff/archive/refs/tags/r1.0.4.tar.gz"
    sha256 "c0a10c0f32aa10f204be5629a6d7e5d74f8ac785dfa19ee68662d0c4ddad749c"

    livecheck do
      url "https://github.com/Fraunhofer-IIS/mmtisobmff.git"
      regex(/^r?(\d+(?:\.\d+)+)$/i)
    end
  end

  deny_network_access!

  def install
    resources.each do |r|
      r.stage do
        system "cmake", "-S", ".", "-B", "build",
               "-DUSE_PKGCONFIG_DEPS=ON",
               *std_cmake_args(install_prefix: buildpath/r.name/"install")
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"
        ENV.prepend_path "PKG_CONFIG_PATH", buildpath/r.name/"install"/"share/pkgconfig"
      end
    end

    system "cmake", "-S", ".", "-B", "build",
           "-Dmpeghdec_BUILD_BINARIES=ON",
           "-DBUILD_SHARED_LIBS=ON",
           "-DUSE_PKGCONFIG_DEPS=ON",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (lib/"pkgconfig").install Dir[share/"pkgconfig/*.pc"]
    rm_r share/"pkgconfig"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <stdio.h>
      #include <mpeghdec/mpeghdecoder.h>

      int main()
      {
          HANDLE_MPEGH_DECODER_CONTEXT decoder = mpeghdecoder_init(2);
          if (decoder == nullptr) {
              fprintf(stderr, "mpeghdecoder_init() failed\\n");
              return 1;
          }

          printf("mpeghdec initialized successfully\\n");
          mpeghdecoder_destroy(decoder);

          return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lmpeghdec", "-o", "test"
    system "./test"
  end
end
