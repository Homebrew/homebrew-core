class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "2ffa9920e9577aa0e351d1703db3a450f41fc5d55117450e9a9ed2b983f0c5b9"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28b3a58673b3f10a4b5e37b61bc99e6a399b16f52cc05987fb9d0f54464eb2be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28b3a58673b3f10a4b5e37b61bc99e6a399b16f52cc05987fb9d0f54464eb2be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28b3a58673b3f10a4b5e37b61bc99e6a399b16f52cc05987fb9d0f54464eb2be"
    sha256 cellar: :any_skip_relocation, sonoma:        "8432d60ed55ea04c2033465d6ade0afcf46b1dda52ded35887f174534e5151e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da4d6199c324e01c0056559a04d05d614bcf7cb412b2333710593ea478208869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c122039e363edde2106af7b833df0d2f12f18ae42c6e9b75e05b214eb8df73ed"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"force")

    generate_completions_from_executable(bin/"force", shell_parameter_format: :cobra)
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
