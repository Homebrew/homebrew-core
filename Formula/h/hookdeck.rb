class Hookdeck < Formula
  desc "Forward webhook events from Hookdeck to a local server"
  homepage "https://hookdeck.com"
  url "https://github.com/hookdeck/hookdeck-cli/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "16b421f3af652ebbea24e445815a750cae51584bc8bd069c2ffaad718b69076c"
  license "Apache-2.0"
  head "https://github.com/hookdeck/hookdeck-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca22512684caeecdf7453c151e70f81f2ff8b05d97a8d40c8e85407ca531d574"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca22512684caeecdf7453c151e70f81f2ff8b05d97a8d40c8e85407ca531d574"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca22512684caeecdf7453c151e70f81f2ff8b05d97a8d40c8e85407ca531d574"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3796a9083db6ac59c9f0c3b8a441dea6328370671b2fcba0f4cb6474a6babd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3479033747b02389540d5243a1c4748ab5fc55eba6840d62471fe5f78dd7eff1"
    sha256 cellar: :any,                 x86_64_linux:  "8b66fa541ada3814150b63a834978ba42f3d37606933550235c5211a8c9a539c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/hookdeck/hookdeck-cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"hookdeck", "completion",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hookdeck --version")
    assert_match "Provide a project API key", shell_output("#{bin}/hookdeck ci 2>&1", 1)
  end
end
