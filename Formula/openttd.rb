class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://cdn.openttd.org/openttd-releases/1.11.1/openttd-1.11.1-source.tar.xz"
  sha256 "a9919e2e429bb08fa29fe8e67ba9bc75c90e9ef6fa64248eb34223a325d400a3"
  license "GPL-2.0-only"
  head "https://github.com/OpenTTD/OpenTTD.git"

  livecheck do
    url :homepage
    regex(/Download stable \((\d+(\.\d+)+)\)/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "0d3994d93730c19736b38cc3b03f773cd379f9ef4b9177956b9e5002f8f7ead4"
    sha256 cellar: :any, catalina: "8954c67873a3aea6a5cf33ab5d7b547b2598c0b45356639e2fdbc748d8e173e4"
    sha256 cellar: :any, mojave:   "70af7ffea9b4c684cd51e56b0b74efc44642915713da8378402d778fe9a80d51"
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

    app = "build/_CPack_Packages/amd64/Bundle/openttd-#{version}-macos-amd64/OpenTTD.app"
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
