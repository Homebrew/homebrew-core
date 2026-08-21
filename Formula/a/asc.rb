class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/4.7.1.tar.gz"
  sha256 "bc47a7a6c052e39053fccc18fa583a9ff3b52f47d66b9c4dc572eff8ae3a7e0e"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c275363745408d0970313d18c20045d92652782b2020798d0f169b0338f1b10b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c9c4a382bf9c520f9cbd84fe54085517606b641280ff36e63acf04495d9ed0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da476de61fc81764431e056f11564b5ffee45c16e1a04e09d2a3eb743bb2fe51"
    sha256 cellar: :any_skip_relocation, sonoma:        "c74c562e4af710d6b14f4a66a1add66c10e64f8fe47e36639552c9e9c26804d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c65292f92dd217546f60b96b0659e8e9b583620e3d343c30158454016e5c6ae"
    sha256 cellar: :any,                 x86_64_linux:  "c894780d1da4b2d93452cc8360ef7bb66e72792efde496de941f0024c0224ac8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
