class Pet < Formula
  desc "Simple command-line snippet manager"
  homepage "https://github.com/knqyf263/pet"
  url "https://github.com/knqyf263/pet/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "b829628445b8a7039f0211fd74decee41ee5eb1c28417a4c8d8fca99de59091f"
  license "MIT"
  head "https://github.com/knqyf263/pet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2abe7b3a10517de5dbd8061c61f2feefab8008c28230024563b305e63a48c15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2abe7b3a10517de5dbd8061c61f2feefab8008c28230024563b305e63a48c15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2abe7b3a10517de5dbd8061c61f2feefab8008c28230024563b305e63a48c15"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4621b4411e7fe453c60a25323f66915c0ea96b6f1ca85ea786ac67681ffbba9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2797febd8ce009dafed282f6d831ba6de4e2b37ddc758b4fababb83a55b105b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f6270812ba6ab77cee2ba10db908a5583c92dbdc8be084620cf6225feccbb6e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/knqyf263/pet/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"pet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pet version")
    assert_empty shell_output("#{bin}/pet list")
  end
end
