class Fheroes2 < Formula
  desc "Recreation of the Heroes of Might and Magic II game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/refs/tags/1.1.11.tar.gz"
  sha256 "e9a70f4cc831231010354cc599c84b626a18e15de1252bc35e4ced720857236c"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cc51a1ff6730edaa217dbb9a2fb40f0fa43411ec860e2d18e4e57df0bbcf1fe6"
    sha256 cellar: :any, arm64_sequoia: "b208fa4c3fc4c41eb5cffe6fb555e5aeda5711447ff5e8887e43cea789a9e552"
    sha256 cellar: :any, arm64_sonoma:  "fc5bc30f9d5802b69a29351582f593ae1c52c74bd75e7ce7b88ce572fc0a9460"
    sha256 cellar: :any, sonoma:        "87d8a0caae5e28f77728057ec11de21d32ffe7507633e6c61cac2db6f3db778e"
    sha256               arm64_linux:   "24fc90ebece47e2974ac76762670d177384e0c4bd1c28b6dacf67ca815314695"
    sha256               x86_64_linux:  "4ed0a90740aa32a136468e9bf82caf90ef9a59fb08375b7368bac43abef077ac"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "innoextract"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  def install
    # Avoid running dylibbundler to prevent copying dylibs
    inreplace "CMakeLists.txt", /^(\s*run_dylibbundler)\s+ALL$/, "\\1"

    args = std_cmake_args
    args << "-DMACOS_APP_BUNDLE=ON" if OS.mac?
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      prefix.install "build/fheroes2.app"
      bin.write_exec_script "#{prefix}/fheroes2.app/Contents/MacOS/fheroes2"

      libexec.install "script/demo/download_demo_version.sh"
      libexec.install "script/demo/download_demo_version_for_app_bundle.sh"
      libexec.install "script/homm2/extract_homm2_resources.sh"
      libexec.install "script/homm2/extract_homm2_resources_for_app_bundle.sh"
      chmod "+x", Dir["#{libexec}/*"]
      bin.write_exec_script libexec/"download_demo_version_for_app_bundle.sh"
      bin.write_exec_script libexec/"extract_homm2_resources_for_app_bundle.sh"
      mv bin/"download_demo_version_for_app_bundle.sh", bin/"fheroes2-install-demo"
      mv bin/"extract_homm2_resources_for_app_bundle.sh", bin/"fheroes2-extract-resources"
    else
      bin.install "script/demo/download_demo_version.sh" => "fheroes2-install-demo"
      bin.install "script/homm2/extract_homm2_resources.sh" => "fheroes2-extract-resources"
    end
  end

  def caveats
    <<~EOS
      Run fheroes2-install-demo command to download and install all the necessary
      files from the demo version of the original Heroes of Might and Magic II game.

      Run fheroes2-extract-resources command to extract all the necessary resource
      files from a legally purchased copy of the original game.

      Documentation is available at:
      #{share}/doc/fheroes2/README.txt
    EOS
  end

  test do
    assert_path_exists bin/"fheroes2"
    assert_predicate bin/"fheroes2", :executable?
    if OS.mac?
      begin
        pid = spawn(bin/"fheroes2")
        sleep 2
      ensure
        Process.kill("SIGINT", pid)
        Process.wait(pid)
      end
    else
      io = IO.popen("#{bin}/fheroes2 2>&1")
      io.any? do |line|
        line.include?("fheroes2 engine, version:")
      end
    end
  end
end
