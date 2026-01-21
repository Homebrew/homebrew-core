class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "https://patriciogonzalezvivo.com/2015/glslViewer/"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  stable do
    url "https://github.com/patriciogonzalezvivo/glslViewer.git",
        tag:      "3.2.4",
        revision: "7eb6254cb4cedf03f1c78653f90905fe0c3b48fb"

    # Backport support for FFmpeg 8
    patch do
      url "https://github.com/patriciogonzalezvivo/vera/commit/74b6ff1eccb7baccdb3f7506377846ef20051de1.patch?full_index=1"
      sha256 "9fe1f83af45a8740bb7bd3322e9b71bd5c3582b7397d68864d4f75e0c83541d4"
      directory "deps/vera"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "71def3742a3b6dcd962ba7fd6cdd972a32eb958457b4e95ecdbd25270260ed0c"
    sha256 cellar: :any,                 arm64_sequoia: "81f3f92b622f746143e0093ae8fc2a285e3d84f3301507ff69afe9928ea5ab3d"
    sha256 cellar: :any,                 arm64_sonoma:  "50ab6a1054838c1bb0149c7d01bafd270e4c60ecaa8fd9224b4edfbf4cecb355"
    sha256 cellar: :any,                 sonoma:        "7fb9c08e7bac8481dcb111484dc3eae1cc737217ae5cf1f97f1fe7752700217e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc1b7fd1658789fd23a044debe30deca835490c7a00409507672a9f9c4c998d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39bc756f9b0b10b57aaf57d366b2d21fcf601d3be5cff1f98a0b7af6610cf755"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg"
  depends_on "glfw"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "mesa"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/io/.", testpath
    pid = spawn bin/"glslViewer", "orca.frag", "-l"
    sleep 1
  ensure
    Process.kill("HUP", pid)
  end
end
