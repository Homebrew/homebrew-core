class Dra < Formula
  desc "Command-line tool to download release assets from GitHub"
  homepage "https://github.com/devmatteini/dra"
  url "https://github.com/devmatteini/dra/archive/refs/tags/0.10.1.tar.gz"
  sha256 "81fc4e6bd174d238932a6415db7029a84acda5f4dc84a285ee0a10c6b3cb3580"
  license "MIT"
  head "https://github.com/devmatteini/dra.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4572111b4b26a0b84922ba246f8660798a5334557cde28a699555c6c9cf04ff7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ff0c05f5f18abeb5b7ab8a655b44668077b9515d17c4fa7ee1eb3b9c4a8f7c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96afb08befb8c9457942ed1546bf3822379c12719340d6f92dbe269bd0b29db9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3c940b7916770ffcb5079ad9822a76f69cbbc34fe35a250fc8f3af8bbba6d3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de7e578ac474e67f021ad220181a74ed92f4587d2a3d2fd93387a0ad08fc87ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f43053be9f80c5628fcf732e2612f349c2587d77f2343cd99d2d47fc99f18b8"
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
