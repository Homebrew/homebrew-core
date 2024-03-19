class Hck < Formula
  desc "Sharp cut(1) clone"
  homepage "https://github.com/sstadick/hck"
  url "https://github.com/sstadick/hck/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "56f1f288778ceb738f1974ec95de10493936f059a93b7f8717f88c1c6d01b67a"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/sstadick/hck.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "891e475f01aeeb650b1828db847ee07cb599c17dbaf0d19827596c87bf1c7d93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30f7c688301cd4aec0be0c3933fa31fbee2eb0294d6e9b4074e31ecc2e0808d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61af5723cbd318a8039590921123d00c8b15f340cd2051ddd41da032845afd76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f29515c298fd34c7a5a14eea5ca3628ac6d0547887d745c1f4291acdd1e8763"
    sha256 cellar: :any_skip_relocation, sonoma:         "85b2d040d1865284254a98e049b010b074e0c96ebde10d7fef1a5c1556009f74"
    sha256 cellar: :any_skip_relocation, ventura:        "5ba9b32234652704f527debeed8ae7e2c4068c234080fdffad7d734480ecf893"
    sha256 cellar: :any_skip_relocation, monterey:       "51a6f46c9751bdf496126402e6eff137a257e583164046ed82e9225c83099cd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "306221d742060825f2bd6d714637abac4a339334a51ea449fe0fde161bc73866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d87dcb0ce645b7804532a41770208580748153d1607eb242dbce0597ea5ddfc5"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = pipe_output("#{bin}/hck -d, -D: -f3 -F 'a'", "a,b,c,d,e\n1,2,3,4,5\n")
    expected = <<~EOS
      a:c
      1:3
    EOS
    assert_equal expected, output

    assert_match version.to_s, shell_output("#{bin}/hck --version")
  end
end
