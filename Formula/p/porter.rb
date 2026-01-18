class Porter < Formula
  desc "App artifacts, tools, configs, and logic packaged as distributable installer"
  homepage "https://porter.sh"
  url "https://github.com/getporter/porter/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "1021cbe8a0aa8dc7d8ca82cb37aab8b44e24218fe03a26b3f9f6c7b10e694c51"
  license "Apache-2.0"
  head "https://github.com/getporter/porter.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d2e6cd91af0e966c8a821789017b81a0f22cfc0e8c9cf4a255ed92f7c852286"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cb4bc83342ce948dba842220f49a0c6ad2ce8a968942d86a8bb3e80006e86b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c727323f0731e8c18a28e7af6861bce624fd58b173cc34b2acbbbeb00b75a319"
    sha256 cellar: :any_skip_relocation, sonoma:        "a08aa9a85a9ba314cdf72d562d4a696146d10f3fa25847a4064a14feb10cdae3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7db333f4042ce5cbd45a23cc16d9fecfbd532989d70b4b63cfcb36a68fc43226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69bfc2a23597a0050b2f267d0bb0f2183a599ed65e79f3a49ac89f282063f412"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X get.porter.sh/porter/pkg.Version=#{version}
      -X get.porter.sh/porter/pkg.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/porter"
    generate_completions_from_executable(bin/"porter", shell_parameter_format: :cobra)
  end

  test do
    assert_match "porter #{version}", shell_output("#{bin}/porter --version")

    system bin/"porter", "create"
    assert_path_exists testpath/"porter.yaml"
  end
end
