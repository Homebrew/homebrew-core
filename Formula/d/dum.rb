class Dum < Formula
  desc "Npm scripts runner written in Rust"
  homepage "https://github.com/egoist/dum"
  url "https://github.com/egoist/dum/archive/refs/tags/v0.1.20.tar.gz"
  sha256 "a1f4890f7edec4b5a376d3d6a30986b13ef8818593732f4a577a35c3c7145503"
  license "MIT"
  head "https://github.com/egoist/dum.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "975c574d188d562cd6a96ea7596200dc1af0863b800472f19ca4e790e3c8b3d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc1a2eb6d29975956f3f6d0197d900dffe8c053bd27454276d59a74d66303250"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b543985f14ec40fe02d399547c13d7c590248a1a04755b80992a63cc9e42a15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d893cad55e091b873833d75218ac6e5ff2ebdb0a65b6af0f819f784ea5e487da"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a2a36f535842db5effd2ebe482db07b634c8f801d75fe91eea29f273aa624e1"
    sha256 cellar: :any_skip_relocation, ventura:       "04fa40d559dd0816671b58404c9e829f8ac6c94bb4f51a8403dfd80419815292"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b601f2b4fa4dd366ab91f84aefd8ce246987edc79721118b4b2fdd40d749708"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9db9dd61b5327e9bde5c5ebffd66076e3a72911012aecd8a8b3fda81057ea26"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "scripts": {
          "hello": "echo 'Hello, dum!'"
        }
      }
    JSON

    output = shell_output("#{bin}/dum run hello")
    assert_match "Hello, dum!", output

    assert_match version.to_s, shell_output("#{bin}/dum --version")
  end
end
