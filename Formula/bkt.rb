class Bkt < Formula
  desc "Utility for caching the results of shell commands"
  homepage "https://www.bkt.rs"
  url "https://github.com/dimo414/bkt/archive/refs/tags/0.5.4.tar.gz"
  sha256 "172c413709dc81ced9dfa2750aaa398864e904d1ed213bd19e51d45d1ff0a8ff"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7012deda4dc41076875dfb71b2939b8fb3d5b70774c800c65cb3995e643a364c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "020ffff4d753c9048f178ca23fe4294e371485e4ffeb75f4fb4771e65c2ed313"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb4994a9537b696ed3aa5327751d6b147ac17c5c32a08d4891c93a547a9fc818"
    sha256 cellar: :any_skip_relocation, monterey:       "bd0ade61029b216b1dd19e0e19ad635df0b39bc9ec2537edbc04278b34213326"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a370ef7c828a155cad72d4776bd14b3a84a1a5ef1b7392741bd4186d5613746"
    sha256 cellar: :any_skip_relocation, catalina:       "c12826cb4085ad2a67eb168cf043c1587df4c6fc876036568bceac64be1874b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf58f99b4e1b064ab039571ddf4956768eaf03a16134cc7fb6e8869f8b3b72a3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Make sure date output is cached between runs
    output1 = shell_output("#{bin}/bkt -- date +%s.%N")
    sleep(1)
    assert_equal output1, shell_output("#{bin}/bkt -- date +%s.%N")
  end
end
