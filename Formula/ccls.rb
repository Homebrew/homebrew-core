class Ccls < Formula
  desc "C/C++ language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls.git", :tag => "0.20180513", :revision => "19d0aad2ca9663b5633b575efe41803005b21d38"
  head "https://github.com/MaskRay/ccls.git"

  option "without-system-clang", "Downloading Clang from http://releases.llvm.org/ during the configure process"

  depends_on "cmake" => :build
  depends_on "llvm" => :build

  def install
    system_clang = build.with?("system-clang") ? "ON" : "OFF"

    args = std_cmake_args + %W[
      -DSYSTEM_CLANG=#{system_clang}
    ]

    ENV.prepend_path "PATH", Formula["llvm"].opt_bin

    if build.stable?
      ENV.append "LDFLAGS", "-lclangBasic"
    end

    mkdir_p "#{buildpath}/release"
    system "cmake", *args, "-Brelease", "-H."
    system "cmake", "--build", "release", "--target", "install"
  end

  test do
    system "#{bin}/ccls", "--test-unit"
  end
end
