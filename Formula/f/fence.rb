class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.27.tar.gz"
  sha256 "78a98ff08b1ec2589b261798750db4d48862beb845ba9f3fcdebc4275a8a21d3"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0682f3492bfcace73e345341449ad2393811da8bfee308b3275ec76955bab2c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0682f3492bfcace73e345341449ad2393811da8bfee308b3275ec76955bab2c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0682f3492bfcace73e345341449ad2393811da8bfee308b3275ec76955bab2c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "55a3bfc498d28f7ef3d12b67da82e755665154d1b32506f8a230ca863de3536d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74b2ae4d5e2db2b2ca7e26a3231cca3e9e7501c984c6deefc27a6de1ba339b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9b2c5b16bddc01f8b4d13407a96031b45125197b8a7d263dbe456b7cedbeff5"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bubblewrap" => :no_linkage
    depends_on "socat" => :no_linkage
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildTime=#{time.iso8601}
      -X main.gitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/fence"

    generate_completions_from_executable(bin/"fence", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fence --version")

    # General functionality cannot be tested in CI due to sandboxing,
    # but we can test that config import works.
    (testpath/".claude/settings.json").write <<~JSON
      {}
    JSON
    system bin/"fence", "import", "--claude", "-o", testpath/".fence.json"
    assert_path_exists testpath/".fence.json"
  end
end
