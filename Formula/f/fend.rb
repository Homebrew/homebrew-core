class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "eb37d1dc6883ec7c181b913d8900d9592cc10ba501a904707500e3a3ae0dcec1"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c2b626d33fa0fb367303d86ebef27690e625fd713a2e681613a50f007132782"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "913a70c1f429d76d1e53fe4446302730e9b97d419400265e5c703d31c0dd945a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44c832ceb3d530054b98059f4fc08545401b03f1011077547040aec18f4aa287"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "228834b97236a5811df63af4a76e8721b7109d0c0b0ad0a55fd1bd158ae4ba1f"
    sha256 cellar: :any_skip_relocation, sonoma:         "be689e1ec26d8838c575fef8177f781fff5dd4886f980385a64b0975386b929b"
    sha256 cellar: :any_skip_relocation, ventura:        "4c57eda5f8445639c9e7e497d49e9d52909e64b96de507572c9634d9781cb0e5"
    sha256 cellar: :any_skip_relocation, monterey:       "3a76348497d5c9736dda12229657e40197f8c0bc3b5ee36926715aa0a46f5b3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "4db4c4a8714387b9d45b286f1ff4a21646a382bf6fbc5a4f551a166a33eac8c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43a9c49421bb492d743224f7429762846912a789d33e0f9b1eae42d8825d0bea"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    system "./documentation/build.sh"
    man1.install "documentation/fend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}/fend 1 km to m").strip
  end
end
