class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "9ef6f9569e037980e9e17e3c3d04e84197321a3f7d75dbcfd867059175f239c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5782968e87c9ba9169f8e117b8536bf7d03d3124bf9df65b2f3963ab8b71442"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1365ebe4b2b9464c0f4ffbfa6de06427b2c873e58eed909a0ced58ef90dda9ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a09f0a5a0a729d9845678a06c65a07702c3c35a547dc64a3f97d8f214907f6a"
    sha256 cellar: :any_skip_relocation, ventura:        "5b578590fe4a8b556f6acc95a4aa85ee6185dd19ff5478bee9b7736b332ee21a"
    sha256 cellar: :any_skip_relocation, monterey:       "4f740b06c5164dcd8f77d1759f7085b481730050773c4a496e4e17303f844e04"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fc3c858f77bedf850b63ad4204ab06b6f73e6ba732ab0a5fd1e1a6bd1115391"
    sha256 cellar: :any_skip_relocation, catalina:       "afca8aef59beca91c86731bad3b650a935092d58885ba1afd855ba6c59281666"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06a473c3bdabf00fd8b2ce5cb7578e1c7e73968951fef32f7944185ae4c2fe94"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", "completion")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
