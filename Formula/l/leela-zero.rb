class LeelaZero < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://zero.sjeng.org/"
  # pull from git tag to get submodules
  url "https://github.com/leela-zero/leela-zero.git",
      tag:      "v0.17",
      revision: "3f297889563bcbec671982c655996ccff63fa253"
  license "GPL-3.0-or-later"
  revision 9

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "85cae46d6ad50e1b55c9e1abbaa02248745b34108f2cfc0808392da051f395eb"
    sha256 cellar: :any,                 arm64_sonoma:  "e9d5144b47601a7df7c5577e6955e485eabe370ded9be2d92bf289c921e3879e"
    sha256 cellar: :any,                 arm64_ventura: "da325324c8d07bc25b9144320a660ed4cda2f2063be15c32804fad0c726763a6"
    sha256 cellar: :any,                 sonoma:        "802f87d15cc5b7a713c5799c90159d48f7b49cd04bda131ba06202a509c55e3a"
    sha256 cellar: :any,                 ventura:       "21f62b985c0c352d1ccf1ec3c363c259682ca28b74fbe76e61ad1dd34046b656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f68323949e99f4584b041b8f310855c30deabc898db999ff306ea2773560ad23"
  end

  depends_on "cmake" => :build
  depends_on "boost"

  uses_from_macos "zlib"

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  resource "network" do
    url "https://zero.sjeng.org/networks/00ff08ebcdc92a2554aaae815fbf5d91e8d76b9edfe82c9999427806e30eae77.gz", using: :nounzip
    sha256 "5302f23818c23e1961dff986ba00f5df5c58dc9c780ed74173402d58fdb6349c"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install resource("network")
  end

  test do
    system bin/"leelaz", "--help"
    assert_match(/^= [A-T][0-9]+$/,
      pipe_output("#{bin}/leelaz --cpu-only --gtp -w #{pkgshare}/*.gz", "genmove b\n", 0))
  end
end
