class Dra < Formula
  desc "Command-line tool to download release assets from GitHub"
  homepage "https://github.com/devmatteini/dra"
  url "https://github.com/devmatteini/dra/archive/refs/tags/0.10.1.tar.gz"
  sha256 "81fc4e6bd174d238932a6415db7029a84acda5f4dc84a285ee0a10c6b3cb3580"
  license "MIT"
  head "https://github.com/devmatteini/dra.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "031cbc375e142c2f2f9900838bf86a81d961d967fd585699dda13eaca25ebd37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "348e9f517772c9f869fdd2016d2df4fa835e2fc54ff8a04451c002e498a39cae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e52533217cb82e1da25963d56222ca2c87890406ff538ec653daf3954b912f27"
    sha256 cellar: :any_skip_relocation, sonoma:        "c762127ac0eb2a0de24933ff71a177edd803cd5a04b7b150e945826dab703e2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9cdbc317602cec10306a6b5571c0b3214405530fb4e8a8b42ccdb7174b3da9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdd8087eba173830ce4c65a84615320b922d46729ba6621c177be947b9ef1e7a"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

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
