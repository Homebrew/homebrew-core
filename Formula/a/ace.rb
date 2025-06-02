class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-8_0_3/ACE+TAO-8.0.3.tar.bz2"
  sha256 "aec961417e5b894a44de9b361fa45966b3267a79a01de1e813a5a4bc021b48bb"
  license "DOC"

  livecheck do
    url :stable
    regex(/^ACE(?:\+[A-Z]+)*?[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "beab881a5b7e15b2ed1864cd2f7a67614efa23bd9bedfead91d39b9295961b06"
    sha256 cellar: :any,                 arm64_sonoma:  "b435bbae4181e2546fdc9ad94921c2410f1e4074ca8429e312d6272583df3d30"
    sha256 cellar: :any,                 arm64_ventura: "a5838652c10aff691c4fb61bd40a51b0c148b468cf99b86bfa819fdb6bd6d072"
    sha256 cellar: :any,                 sonoma:        "0760f394c21ddea1fc54966c8ec4985efb9f97a2d28cecdee06f9a0b59971428"
    sha256 cellar: :any,                 ventura:       "6d57e6d354cb890dd008d36a5557b1e13454cd5a15b54c8ed7c9fc8ce544798d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bd5b17c2db2b7928732d6c8fc7444ac2e781d1021fa714ed5695e96d88d482c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "848d8135c3004cde97ef40b6fe4aca6a40b226c99d6c54499fc597caa5b76ee6"
  end

  def install
    os = OS.mac? ? "macosx" : "linux"
    ln_sf "config-#{os}.h", "ace/config.h"
    ln_sf "platform_#{os}.GNU", "include/makeinclude/platform_macros.GNU"

    ENV["ACE_ROOT"] = buildpath
    ENV["DYLD_LIBRARY_PATH"] = "#{buildpath}/lib"

    # Done! We go ahead and build.
    system "make", "-C", "ace", "-f", "GNUmakefile.ACE",
                   "INSTALL_PREFIX=#{prefix}",
                   "LDFLAGS=",
                   "DESTDIR=",
                   "INST_DIR=/ace",
                   "debug=0",
                   "shared_libs=1",
                   "static_libs=0",
                   "install"

    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}" if OS.mac?
    system "make", "-C", "examples/Log_Msg"
    pkgshare.install "examples"
  end

  test do
    cp_r "#{pkgshare}/examples/Log_Msg/.", testpath
    system "./test_callback"
  end
end
