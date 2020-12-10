class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/0.10.1.tar.gz"
  sha256 "98144d0a66a1fe8f0529d0b973dd70d72915dbe3602f5cb58e7fb555e8be81a2"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 "ecfce356cd0f4b376a1a8cb7350dc32dc8103a6f88b3c80899237918d02aabee" => :big_sur
    sha256 "47c3ec4b25b74d6eaddcc637e0af2b79c7c9c5e30fce053586280427c1e47dd1" => :catalina
    sha256 "3bc1ed2ed0e30ac32ebe50997ead19a53b57aa40b9d1f0c2c3de5420e545ebbd" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on :macos # Due to Python 2 in buildtime
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/12/ba/d6d9f1432663ab5623f761c86be11e7f2f6fb28348612f48fb082d3cfcea/protobuf-3.14.0.tar.gz"
    sha256 "1d63eb389347293d8915fb47bee0951c7b5dab522a4a60118b9a18f33e21f8ce"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(buildpath/"vendor")
      end
    end
    # Protobuf package doesn't play nicely with Python 2.7
    touch buildpath/"vendor/lib/python2.7/site-packages/google/__init__.py"

    args = std_cmake_args
    args << "-DCDOGS_DATA_DIR=#{pkgshare}/"
    system "cmake", ".", *args
    system "make"
    bin.install %w[src/cdogs-sdl src/cdogs-sdl-editor]
    pkgshare.install %w[data dogfights graphics missions music sounds]
    doc.install Dir["doc/*"]
  end

  test do
    pid = fork do
      exec bin/"cdogs-sdl"
    end
    sleep 7
    assert_predicate testpath/".config/cdogs-sdl",
                     :exist?, "User config directory should exist"
  ensure
    Process.kill("TERM", pid)
  end
end
