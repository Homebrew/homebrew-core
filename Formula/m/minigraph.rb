class Minigraph < Formula
  desc "Proof-of-concept seq-to-graph mapper and graph generator"
  homepage "https://lh3.github.io/minigraph"
  url "https://github.com/lh3/minigraph/archive/refs/tags/v0.21.tar.gz"
  sha256 "4272447393f0ae1e656376abe144de96cbafc777414d4c496f735dd4a6d3c06a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48bcee41e459f118349bccc93b32a9e721ce9835f293b32ffc168edae3b6f900"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "013ee66a3369941bfc4fdde7418fd2fbb51247646b89db97334d68c1461abd4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06d84e9c314550c79a857c908cc7f586cf2972281d0db97e6dd0dd36cbdaa534"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3bef0a3f41f36ffb586b5c531507f33a2f2b3fc83df47d788a799a596f798a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "909088318ee79b855fdedb8cb5228a4a5586dc05b8e09b46165b10230032b773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "777e02e932c650e53510af0b618c5d39db20e675450f6adf19ad49220b659b94"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    sse4 = Hardware::CPU.intel? && ((OS.mac? && MacOS.version.requires_sse4?) ||
                                    (!build.bottle? && Hardware::CPU.sse4?))
    unless sse4
      inreplace "Makefile" do |s|
        cflags = s.get_make_var("CFLAGS").split
        cflags.delete("-msse4") { |flag| "Remove inreplace for #{flag}!" }
        s.change_make_var! "CFLAGS", cflags.join(" ")
      end
    end

    system "make"
    bin.install "minigraph"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/.", testpath
    output = shell_output("#{bin}/minigraph MT-human.fa MT-orangA.fa 2>&1")
    assert_match "mapped 1 sequences", output
  end
end
