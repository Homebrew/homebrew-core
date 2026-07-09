class Muscle < Formula
  desc "Multiple sequence alignment program"
  homepage "https://drive5.com/muscle/"
  url "https://github.com/rcedgar/muscle/archive/refs/tags/v5.3.tar.gz"
  sha256 "74b22a94e630b16015c2bd9ae83aa2be2c2048d3e41f560b2d4a954725c81968"
  license "GPL-3.0-only"
  head "https://github.com/rcedgar/muscle.git", branch: "main"

  depends_on "python@3.14" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
    depends_on "libomp"
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with :clang do
    build 1699
    cause "Requires C++20"
  end

  # Upstream's build scripts (src/build_osx.bash, src/build_linux.bash) download
  # this helper to build the Visual Studio project on POSIX systems; vendor it
  # pinned to the same commit those scripts use.
  resource "vcxproj_make" do
    url "https://raw.githubusercontent.com/rcedgar/vcxproj_make/806d016/vcxproj_make.py"
    sha256 "902735703004c47705ffa389329378f237fecb154945b489edf6abe260c6694f"
  end

  def install
    resource("vcxproj_make").stage buildpath/"src"
    cd "src" do
      if OS.mac?
        ENV["CPPFLAGS"] = "-Xpreprocessor -I#{formula_opt_include("libomp")}"
        ENV["LDFLAGS"] = "-L#{formula_opt_lib("libomp")} -lomp"
      else
        inreplace "vcxproj_make.py", "-static", ""
      end
      system formula_opt_bin("python@3.14")/"python3.14", "vcxproj_make.py",
             "--openmp", "--cppcompiler", ENV.cxx, "--ccompiler", ENV.cc
    end
    bin.install "bin/muscle"
    pkgshare.install "test_data"
  end

  test do
    assert_match "muscle", shell_output("#{bin}/muscle -version")
    system bin/"muscle", "-super5", pkgshare/"test_data/fa/BB11001", "-output", "out.fna"
    assert_path_exists testpath/"out.fna"
  end
end
