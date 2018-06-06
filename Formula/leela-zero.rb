class LeelaZero < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "http://zero.sjeng.org/"
  # pull from git tag to get submodules
  url "https://github.com/leela-zero/leela-zero.git",
      :tag      => "v0.16",
      :revision => "4fd6e694ead45b7cbb14ea76c5bdfcbfa662304b"
  head "https://github.com/leela-zero/leela-zero.git", :branch => "next"

  depends_on "cmake" => :build
  depends_on "boost"

  resource "network" do
    url "https://zero.sjeng.org/networks/2d46c3273204ba8e41bc2daffd61c42da275401321f4f7a62e45f26472b7c8c2.gz", :using => :nounzip
    sha256 "732229be158bfb795f558b32fd9f84d28675d21cd6559794e3eabbd28840d0d8"
  end

  def install
    mkdir "build"
    cd "build" do
      system "cmake", "-DUSE_CPU_ONLY=1", ".."
      system "cmake", "--build", "."
      system "./tests"
      bin.install "leelaz"
    end
    pkgshare.install resource("network")
  end

  def caveats
    <<~EOS
      This formula also downloads the currently best-trained set of network
      weights. They are stored in #{opt_pkgshare}/

      To use this network, pass the `-w <path>` parameter to leelaz. You can also
      download the latest networks as they improve from https://zero.sjeng.org/network-profiles
    EOS
  end

  test do
    system "#{bin}/leelaz", "--help"
    assert_match /^= [A-T][0-9]+$/, pipe_output("#{bin}/leelaz --gtp -w #{pkgshare}/*.gz", "genmove b\n", 0)
  end
end
