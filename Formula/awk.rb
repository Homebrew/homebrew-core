class Awk < Formula
  desc "Text processing scripting language"
  homepage "https://www.cs.princeton.edu/~bwk/btl.mirror/"
  url "https://github.com/onetrueawk/awk/archive/20220122.tar.gz"
  sha256 "720a06ff8dcc12686a5176e8a4c74b1295753df816e38468a6cf077562d54042"
  # https://fedoraproject.org/wiki/Licensing:MIT?rd=Licensing/MIT#Standard_ML_of_New_Jersey_Variant
  license "MIT"
  head "https://github.com/onetrueawk/awk.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47f3d16ebd3eb5767c9053091532d69d2c8288a262f9007301b757639833ffdb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bb8fdb607cba55ad0f173881e83f8f83ffbd3f2cbf84ca26a494cf614d6d3f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "253a8eb03a628051cc748336648bc984e4a2bb04322a06c8d8e2e43798d5f581"
    sha256 cellar: :any_skip_relocation, ventura:        "4c14575b3b5c52aa4b7064bfa737e7a2cce5bf00643883f71be87f509fceb546"
    sha256 cellar: :any_skip_relocation, monterey:       "7ab4bfa6706a1cad2f1990962b8067e359da9f49079803c7628483e97a0e396d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d566709d5824930ffecb61d05d86e724bf54c3956964ed39b3a3fffaac3b60e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b9a89dc8999517cda6105d5c5e0e94294aba8f507aa85b21ee9a3a75c08a0a7"
  end

  uses_from_macos "bison"

  on_linux do
    conflicts_with "gawk", because: "both install an `awk` executable"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "a.out" => "awk"
    man1.install "awk.1"
  end

  test do
    assert_match "test", pipe_output("#{bin}/awk '{print $1}'", "test")
  end
end
