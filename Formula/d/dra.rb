class Dra < Formula
  desc "Command-line tool to download release assets from GitHub"
  homepage "https://github.com/devmatteini/dra"
  url "https://github.com/devmatteini/dra/archive/refs/tags/0.10.3.tar.gz"
  sha256 "f37abf2c8bb2ed19789e6ec98ef8e03120be2312f29964911b2227439ce08b0e"
  license "MIT"
  head "https://github.com/devmatteini/dra.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "88772cfa29930ceda408bae23d34dc9fabac52c5682f07ae039a6bbad3e96135"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e2c3de62218780515b8661681c71c05e233397b35dcf73f0c8799018248c73b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0487f14e52ed15e57b4a7301dda259dffa5e5999c2fb9927f990f0c73f98e5e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "0791469e6708473fb4c316fdf21af5c447d8de83ed7bfca5a7611aa863df53c9"
    sha256 cellar: :any,                 arm64_linux:       "f924c90367a946b808d46ad716e63600a3287afa820f5fa5f84e2b851fcdfb89"
    sha256 cellar: :any,                 x86_64_linux:      "13f85305ae98dc0926a0d797b159d889ecb7f5c8a0bb37c140009d2a7a4a8ca8"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dra", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dra --version")

    system bin/"dra", "download", "--select",
           "helloworld.tar.gz", "devmatteini/dra-tests"

    assert_path_exists testpath/"helloworld.tar.gz"
  end
end
