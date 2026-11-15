class Modflow6 < Formula
  desc "USGS modular hydrologic model"
  homepage "https://www.usgs.gov/software/modflow-6-usgs-modular-hydrologic-model"
  url "https://github.com/MODFLOW-ORG/modflow6/archive/refs/tags/6.8.2.tar.gz"
  sha256 "f40c64d333cf2d5089bb777cb296aa05a8b4ba11a49a1602d6e5e8626019dade"
  license "CC0-1.0"
  head "https://github.com/MODFLOW-ORG/modflow6.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2b9b464b0b1cebc7dc22822b1df9e21f1b83a2fd40df5d62b65f7811e915510a"
    sha256 cellar: :any, arm64_tahoe:       "cc8c167ce65886751d438a3ebff4033ecd70b516e4d90b918900201681298e71"
    sha256 cellar: :any, arm64_sequoia:     "07a4ad99135c42d13edeb566db37e73b4ade8573496bd304d93e6b6782f29c4f"
    sha256 cellar: :any, arm64_linux:       "64e489d79d6ed71b34e32fd223f4ccdb20da7f7d092ec0a71de37decac960d2e"
    sha256 cellar: :any, x86_64_linux:      "43a88d58e4dc23d5596d8f716e7914750466d20876ba4614049ccc8e22b52d59"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gcc" # for gfortran

  deny_network_access!

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install ".mf6minsim" => "mf6minsim"

    # zbud6 is a utility built by the default meson targets and is not packaged
    rm bin/"zbud6"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mf6 --version")

    cp_r pkgshare/"mf6minsim/.", testpath
    system bin/"mf6"
    assert_match "Normal termination of simulation", (testpath/"mfsim.lst").read

    # run the same one-step simulation through libmf6
    rm testpath/"mfsim.lst"
    (testpath/"test.c").write <<~C
      int initialize(void), update(void), finalize(void);
      int main(void) { return initialize() || update() || finalize(); }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lmf6", "-Wl,-rpath,#{lib}", "-o", "test"
    system "./test"
    assert_match "Normal termination of simulation", (testpath/"mfsim.lst").read
  end
end
