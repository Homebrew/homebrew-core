class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.26.1.tar.gz"
  sha256 "1e458599306bdfbe498418363c0e375bd75e9ae99676033ef3035f43cbd43dfd"
  license "MIT"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aed89a4331626f769cf82f04953ccd11a56e1cb10b7ab4d9df9ff1cc838cb3ee"
    sha256 cellar: :any_skip_relocation, big_sur:       "f891c71fe183f54096242a21e2447cdf5220a29f354a09afd7bf2d1dfdc0a10c"
    sha256 cellar: :any_skip_relocation, catalina:      "928e99e3ae98d0e02dc83ae1027feb31522fc0e0174a3d1e3a6870fad40f90fa"
    sha256 cellar: :any_skip_relocation, mojave:        "e3443a9460e2e4e580e5545507bb808fc28d22707844142273e0a1bc74d7f24b"
  end

  depends_on "ldc" => :build
  depends_on "pkg-config"

  uses_from_macos "curl"

  def install
    ENV["GITVER"] = version.to_s
    system "ldc2", "-run", "./build.d"
    system "bin/dub", "scripts/man/gen_man.d"
    bin.install "bin/dub"
    man1.install Dir["scripts/man/*.1"]
    zsh_completion.install "scripts/zsh-completion/_dub"
    fish_completion.install "scripts/fish-completion/dub.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end
