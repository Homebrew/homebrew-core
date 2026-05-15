class Fheroes2 < Formula
  desc "Recreation of the Heroes of Might and Magic II game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/refs/tags/1.1.15.tar.gz"
  sha256 "f69c103da4eb1028e84fd87878fa71275651b52cef9f01716e2a870a6aa01c63"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9615d16771a9972551505d16984b124f913b559ff1457913086603187587c73e"
    sha256 cellar: :any, arm64_sequoia: "c0a8ac70e4cd96640231c8d0e29cdd872344aabf9f9fb1460f8e86e6194eccdd"
    sha256 cellar: :any, arm64_sonoma:  "4c18772a320b4485519f9b39a642b0256baa80673ae7c38e19b6ebc632eb6313"
    sha256 cellar: :any, sonoma:        "56ff3371af65b4c9842838f370efc6f008cd1fae4c294e21c0f187f525905eb4"
    sha256               arm64_linux:   "22335fbbc4f40608efb83ea56e534be5f774725bf074bdb9d6d967368c76f3ea"
    sha256               x86_64_linux:  "03eab61996ddb4676e72e17b2dafe3626e0abbe19e46b317bf650f3b8fd441f7"
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
