class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://cdn.openttd.org/openttd-releases/12.0/openttd-12.0-source.tar.xz"
  sha256 "bba0fd3800df0370259e642d251f362c7c00b478a2e3531f6ba7f84c1c2b32dc"
  license "GPL-2.0-only"
  head "https://github.com/OpenTTD/OpenTTD.git", branch: "master"

  livecheck do
    url :homepage
    regex(/Download stable \((\d+(\.\d+)+)\)/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "9cb8cb39bf79d0238d2dc27f38feae95f32a1a04851f9dbc8da9e95b61bf103f"
    sha256 cellar: :any, catalina: "f9ebc96147147720482c14c3528c294cd1f40b97044731f4a1322800db367df4"
    sha256 cellar: :any, mojave:   "7bc30bdbb5a9bfa9adbf6a9c948ae4de761f046a69f0b24d088104b72f60f2bd"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "lzo"
  depends_on macos: :high_sierra # needs C++17
  depends_on "xz"

  resource "opengfx" do
    url "https://cdn.openttd.org/opengfx-releases/0.6.1/opengfx-0.6.1-all.zip"
    sha256 "c694a112cd508d9c8fdad1b92bde05e7c48b14d66bad0c3999e443367437e37e"
  end

  resource "openmsx" do
    url "https://cdn.openttd.org/openmsx-releases/0.4.0/openmsx-0.4.0-all.zip"
    sha256 "7698cadf06c44fb5e847a5773a22a4a1ea4fc0cf45664181254656f9e1b27ee2"
  end

  resource "opensfx" do
    url "https://cdn.openttd.org/opensfx-releases/1.0.1/opensfx-1.0.1-all.zip"
    sha256 "37b825426f1d690960313414423342733520d08916f512f30f7aaf30910a36c5"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "cpack || :"
    end

    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch
    app = "build/_CPack_Packages/amd64/Bundle/openttd-#{version}-macos-#{arch}/OpenTTD.app"
    resources.each do |r|
      (buildpath/"#{app}/Contents/Resources/baseset/#{r.name}").install r
    end
    prefix.install app
    bin.write_exec_script "#{prefix}/OpenTTD.app/Contents/MacOS/openttd"
  end

  test do
    assert_match "OpenTTD #{version}\n", shell_output("#{bin}/openttd -h")
  end
end
