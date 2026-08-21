class Fracturedjson < Formula
  desc "JSON formatter that produces highly readable but fairly compact output"
  homepage "https://github.com/j-brooke/FracturedJson"
  url "https://github.com/j-brooke/FracturedJson/archive/refs/tags/cli-v1.0.1.tar.gz"
  sha256 "9da9a09e1e512b114b220620cc2bdfe2db491eb8094d87a0b773d88a855e16c0"
  license "MIT"

  livecheck do
    url :stable
    regex(/cli[._-]v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dd71fb03ea6e15ff2b4b34255d76f7fb64a29e5b0098351b761ba1510cb74c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2332fa83fc6098c1a04abd37f49e5be41e25005bc602ed039d77eee1496e19eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa6cd255c0057de51c05083eab084469b33d58ed125d2c2991cfede101facf06"
    sha256 cellar: :any_skip_relocation, sonoma:        "31a5bd6552911fa0189e96031aac99bb82002fde4542118a7c95eeb852c247c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb23fe5446b5e3aa8990fee78c14ec5c98ef5a4d47ae47da812cd17b3fc9d286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53d0d41ec51fb341e160e8b01756124139cf983c118bdb7001d3023f5acc5cec"
  end

  depends_on "dotnet" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os_tag = OS.mac? ? "osx" : "linux"
    args = %W[
      --configuration Release
      --runtime #{os_tag}-#{arch}
      --output #{libexec}
      --property InvariantGlobalization=true
    ]
    system "dotnet", "publish", "Cli/Cli.csproj", *args
    bin.install_symlink libexec/"fracjson"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fracjson --version")

    input_json = <<~JSON
      {"BasicObject":{"ModuleId":"armor","Locations":[[11,2],[11,3],[11,4],[11,5],[11,6],[11,7],[11,8],[11,9],[11,10],[11,11],[11,12],[11,13],
      [11,14],[1,14],[1,13],[1,12],[1,11],[1,10],[1,9],[1,8],[1,7],[1,6],[1,5],[1,4],[1,3],[1,2],[4,2],[5,2],[6,2],[7,2]],"Seed":272691529},
      "SimilarArrays":{"Katherine":["blue","lightblue","black"],"Logan":["yellow","blue","black","red"],"Erik":["red","purple"]}}
    JSON
    output = pipe_output("#{bin}/fracjson", input_json, 0).chomp
    assert_operator output.lines.count, :>, 3
  end
end
