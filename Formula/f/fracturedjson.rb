class Fracturedjson < Formula
  desc "JSON formatter that produces highly readable but fairly compact output"
  homepage "https://github.com/j-brooke/FracturedJson"
  url "https://github.com/j-brooke/FracturedJson/archive/refs/tags/cli-v1.0.2.tar.gz"
  sha256 "039e199c246206cb7a01dc800d10c60aced0e26572660c10148c7e6f303e3ab3"
  license "MIT"

  livecheck do
    url :stable
    regex(/cli[._-]v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fb1459aab4722e0c94ff97bbfb8e1e94d47ff8c4a54956b86ae0b35d830ab252"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "abb2da14912a49e0c78f00d589e486d7fb6f5a3c024833bf957fdcb78b795a87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "24ec04771ada599b928f6fc4fedd45ee5e16e670b03959d9781fb1650526507e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "4f118eca5e7ed9c0ee83255cccd608469d1dc31b3ee1f5b0c49952d831d7a76d"
    sha256 cellar: :any,                 arm64_linux:       "1e5d27d48dba85088a5f9a667946137acd1b5fbace83cc5ed71c95b37d881d83"
    sha256 cellar: :any,                 x86_64_linux:      "a010c974d6327aa06d0a2a31ea18b84da90db6d9e7f54d863eb496f7c78b6353"
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
