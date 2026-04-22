class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://github.com/lsof-org/lsof"
  url "https://github.com/lsof-org/lsof/archive/refs/tags/4.99.6.tar.gz"
  sha256 "2ce65158694e9c44dfc54916f5b843d887763c03128e0a1c77d62ae106537009"
  license "lsof"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "723b4a385c26103601f2309aae631784ea0420ef8d8dcbd7d256ad87a63af911"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "420dd43dcedb7d1eee67d84de4a9683587962269489d010c2764229864f12546"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20e7f80ae4e4b0180843c28c3f2c2d98391398f3f85f37523cad93424bdd1493"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c7c40e806f10f7dadca60932e52e6a8bd26f4d3126736deb24ec3bb27066cbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b13c6ef92722757432ad9a88024de642764e9b6aa7e145b4ca64757a69802223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf1994152f5a772548fc87218819a1384d2998b4105764b4424cbe5e8d43bde2"
  end

  keg_only :provided_by_macos

  on_linux do
    depends_on "libtirpc"
  end

  def install
    if OS.mac?
      ENV["LSOF_INCLUDE"] = MacOS.sdk_path/"usr/include"

      # Source hardcodes full header paths at /usr/include
      inreplace "lib/dialects/darwin/machine.h", "/usr/include", MacOS.sdk_path/"usr/include"
    else
      ENV["LSOF_INCLUDE"] = HOMEBREW_PREFIX/"include"
    end

    ENV["LSOF_CC"] = ENV.cc
    ENV["LSOF_CCV"] = ENV.cxx

    mv "00README", "README"
    system "./Configure", "-n", OS.kernel_name.downcase

    system "make"
    bin.install "lsof"
    man8.install "Lsof.8"
  end

  test do
    (testpath/"test").open("w") do
      system bin/"lsof", testpath/"test"
    end
  end
end
