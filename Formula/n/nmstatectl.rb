class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://github.com/nmstate/nmstate/releases/download/v2.2.59/nmstate-2.2.59.tar.gz"
  sha256 "16ebda604f576c1cb9344dae46045048613339e88af99ae7b49e48237938ea4a"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a85d3d178668d388dd179d97d6555062a7e0c14f4b196e679997dbcaf947cc5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "396ff73fb007c7579625a05e328126f22df7cb676c032ddbc1dea8bd046c721e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b1e1fd00068726a9f1943a99b60f2dc82999989395f896d46ce5466837a0e42"
    sha256 cellar: :any_skip_relocation, sonoma:        "66d267584622c2a057d81840d7c8a1f50c842ebd2d83f717ff0efe31c249898c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "587b55f6655e117b2333cad8f86bfd26a0956c4717d66400fcf3dd55740ef901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a536ee2d49aefbc614b2db14cd73a0d4c367fc755bc69efe7efee8bd781d0dad"
  end

  depends_on "rust" => :build

  def install
    cd "rust" do
      if OS.mac?
        args = ["--no-default-features"]
        features = ["gen_conf"]
      end
      system "cargo", "install", *args, *std_cargo_args(path: "src/cli", features:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nmstatectl --version")

    assert_match "interfaces: []", pipe_output("#{bin}/nmstatectl format", "{}", 0)
  end
end
