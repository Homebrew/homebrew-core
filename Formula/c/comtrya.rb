class Comtrya < Formula
  desc "Configuration and dotfile management tool"
  homepage "https://comtrya.dev"
  url "https://github.com/comtrya/comtrya/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "22634bb01f3758007bbb36f9ffdb3c9d4b55471dc23ee66f1ef21b80a23a5751"
  license "MIT"
  head "https://github.com/comtrya/comtrya.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d99de805a7da0902d1a3f95d154dca2bcdf003de793c086e7117e96ade73f63e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ae9e915d1deda6cef037b3f676f3c07cb2c073779d4555822ebbaa83544f8f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1dc0339997dc21f6dcbe1432ecfd7452eb7b0fa6e99cb03dbf1e606ecd42778"
    sha256 cellar: :any_skip_relocation, sonoma:        "826d318835757025df4eec7bb3857f70cce8af7dd19a7a31d747697f2dc19abe"
    sha256 cellar: :any_skip_relocation, ventura:       "0df65065cec8fad7f2897ebba6371fb3d9662678fd1591a1786b6767e505f174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8862c76fc1d14754c66edb7e3d7b886d45c5e05f2721d02c94ef270178edd38"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "app")

    generate_completions_from_executable(bin/"comtrya", "gen-completions")
  end

  test do
    assert_match "comtrya #{version}", shell_output("#{bin}/comtrya --version")

    resource "testmanifest" do
      url "https://raw.githubusercontent.com/comtrya/comtrya/refs/heads/main/examples/onlyvariants/main.yaml"
      sha256 "0715e12cbbb95c8d6c36bb02ae4b49f9fa479e2f28356b8c1f3b5adfb000b93f"
    end

    resource("testmanifest").stage do
      system bin/"comtrya", "-d", "main.yaml", "apply"
    end
  end
end
