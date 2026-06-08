class Fheroes2 < Formula
  desc "Recreation of the Heroes of Might and Magic II game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/refs/tags/1.1.16.tar.gz"
  sha256 "b5ecc32c199f00b930097f68d8654451ba415c573ef4d808744c55b6650f6084"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "be682f20a41d0981fddb80aca2e805624cb584235f84a3ea745fbed76fab52c2"
    sha256 cellar: :any, arm64_sequoia: "c148e958fa943e66ea428a1336d6e83e5c357441541b3334972198b8debbbc5c"
    sha256 cellar: :any, arm64_sonoma:  "d7b0e6de184fc1686b97b1033c09b1a198ad905a188030dff0b4d38c05412d3e"
    sha256 cellar: :any, sonoma:        "3c16e9073fb5a8c619baa0e9390706fe60b1b58471602cffe1eb4bca53d7d82f"
    sha256               arm64_linux:   "197b30e1c30e3dc80ac515bc9f5a466a4fd1f22b538261609a268f3920f9d85c"
    sha256               x86_64_linux:  "bca6a2c2704b2f588364236d182bee4c422675ea3784036e8232fda0e9df9f1f"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "innoextract"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Avoid running dylibbundler to prevent copying dylibs
    inreplace "CMakeLists.txt", /^(\s*run_dylibbundler)\s+ALL$/, "\\1"

    args = ["-DMACOS_APP_BUNDLE=ON"] if OS.mac?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
