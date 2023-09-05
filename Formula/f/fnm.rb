class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://github.com/Schniz/fnm"
  url "https://github.com/Schniz/fnm/archive/v1.35.1.tar.gz"
  sha256 "df0f010f20e6072a8a52365f195cc94c35ebaf486cc285948e10eabf768d17ba"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fbb22cacea5d3c7cb42475dd7e43201a5d116d50fdb43e95385eb1b68885eeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5350206d2303e2d245677faad2703e15693d21215287291c07723544a0c61eab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba67a51982008afc40abec26132c44d7fcd954a3412a129aa1cb6a92489fa448"
    sha256 cellar: :any_skip_relocation, ventura:        "fd850b0d6e3bd8e97ed402d375727d593b59cc44a90131a2229ed1c3e0110296"
    sha256 cellar: :any_skip_relocation, monterey:       "88a723fa5287e9b1dc257234c7097988039a9283a166d9e9ef54ee25a5c7680f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9afda928770a16c931ef8d3dbacf31add4c2e02d194f5793fc75827a911684ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "147002d566459f7ec65e3b887b96de216d00d77772313e693cd1c9640033245a"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fnm", "completions", "--shell")
  end

  test do
    system bin/"fnm", "install", "19.0.1"
    assert_match "v19.0.1", shell_output("#{bin}/fnm exec --using=19.0.1 -- node --version")
  end
end
