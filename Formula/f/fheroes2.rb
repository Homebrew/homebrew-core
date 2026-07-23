class Fheroes2 < Formula
  desc "Recreation of the Heroes of Might and Magic II game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/refs/tags/1.1.17.tar.gz"
  sha256 "29f0be1a15ecce658e647b8c3d3fe2e6acddf6fa2144b1e05c82984846f568a1"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "878cfa8eb85196e83fd74b55f83c5d97c36e0edc93984fadd876104cf2b61f7f"
    sha256 cellar: :any, arm64_sequoia: "69fd136cb1953c8411b8177bb0d9585d410deed4fc59c46a2bd2cdcf7f9d7817"
    sha256 cellar: :any, arm64_sonoma:  "e7a134f5a1d7a129fbde3d23ac64a12154c7d5615c2ddf82a5f5b1fc18b12ff4"
    sha256 cellar: :any, sonoma:        "805c8fe3209c3956dc3cd20c114b768335a94fdaa5b0b5f2e81751d1441d0ada"
    sha256               arm64_linux:   "5a90b5be8f3d31374d1958624cce9d94a168baae2997f82d5b0e89894d88f39b"
    sha256               x86_64_linux:  "5709d2a7e0caf309bc449450e7986f949eee70dc2e886d2cbf920e5796beea47"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "innoextract"
  depends_on "sdl2-compat"
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
