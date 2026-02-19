class Jxrlib < Formula
  desc "Tools for JPEG-XR image encoding/decoding"
  homepage "https://tracker.debian.org/pkg/jxrlib"
  url "https://deb.debian.org/debian/pool/main/j/jxrlib/jxrlib_1.2~git20170615.f752187.orig.tar.xz"
  version "1.2_git20170615-f752187"
  sha256 "3e3c9d3752b0bbf018ed9ce01b43dcd4be866521dc2370dc9221520b5bd440d4"
  license "BSD-2-Clause"
  version_scheme 1

  livecheck do
    url "https://deb.debian.org/debian/pool/main/j/jxrlib/"
    regex(/href=.*?jxrlib[._-]v?(\d+(?:\.\d+)+[^"' >]*?)\.orig\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map do |match|
        match[0].tr("~", "_").sub(/\.(\h{7})$/, '-\1')
      end
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "c4b636123bafc19b44451cfc90eecbf7ab7488527508c40a102594517d60c889"
    sha256 cellar: :any,                 arm64_sequoia:  "e7aae93b96e812a888ab0a4da737a40fef17bb389a7e3bcc5106ff81c33a7841"
    sha256 cellar: :any,                 arm64_sonoma:   "437e4ba50db36d58d3c043f6a3a1e34939f0e80f1318160d9d142da27f222e47"
    sha256 cellar: :any,                 arm64_ventura:  "a81a86a6bc199eac66b8c9ae3b40a942c2acd8986b2c901e165f2ebb99e466f1"
    sha256 cellar: :any,                 arm64_monterey: "2faf5cbf70c5f9fc6d93dd9449b53db9304bbfcb73a48bf58e935f5cee6f9939"
    sha256 cellar: :any,                 sonoma:         "212c5e081a76c9e8e669e025a09bc57a2ca86454eb18dc902809af560a0530fc"
    sha256 cellar: :any,                 ventura:        "449029d8100d5ed878755410d3c23b3044f4033afb5a384886fd2db2b0994434"
    sha256 cellar: :any,                 monterey:       "1b98aa039650e79119c061342a8ccf2e6ef8d0872893ad12c1bfefac67a8d88d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0db591f53b1290c104b0f916fc03d356174efe49822436a3548a0aadb4110b43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8b4edc2fe9b2af8b4ac16fc72f1ac97c7c2bd61186250e2edb55c2cd632527d"
  end

  depends_on "cmake" => :build

  # Enable building with CMake. Adapted from Debian patch.
  patch do
    url "https://raw.githubusercontent.com/Gcenx/macports-wine/1b310a17497f9a49cc82789cc5afa2d22bb67c0c/graphics/jxrlib/files/0001-Add-ability-to-build-using-cmake.patch"
    sha256 "beebe13d40bc5b0ce645db26b3c8f8409952d88495bbab8bc3bebc954bdecffe"
  end

  def install
    inreplace "CMakeLists.txt", "@VERSION@", version.to_s
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    bmp = "Qk06AAAAAAAAADYAAAAoAAAAAQAAAAEAAAABABgAAAAAAAQAAADDDgAAww4AAAAAAAAAAAAA////AA==".unpack1("m")
    infile  = "test.bmp"
    outfile = "test.jxr"
    File.binwrite(infile, bmp)
    system bin/"JxrEncApp", "-i", infile,  "-o", outfile
    system bin/"JxrDecApp", "-i", outfile, "-o", infile
  end
end
