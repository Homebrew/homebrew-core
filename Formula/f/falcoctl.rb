class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "078f256a7f97beb74a2936a39762185f573fef7f3daf12e390eb5882a45347d6"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4895aa77c0f03fe73f34d08338aeb59458a5d8e554430f3f52917f1d0e6ceef7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5b00062f009f131fef27d496adc22cf89eff8e568b2a3e4c5e9cc07b0dc8f08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d8a4b520547e521b500b9a93778fda7c863008a599308032320109f918af822"
    sha256 cellar: :any_skip_relocation, sonoma:        "da8bbceafcbac2455bdc1e0a28f3a0acf2c4ef56a05f1aa6bf76426664ff04f1"
    sha256 cellar: :any_skip_relocation, ventura:       "ff1c053d2f9d00812c95aa28aaefa8dc2b45c9d8c76f79fdaddf681f53efd454"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "517ea9d52bd1b35d6fdb20d9189d744da32818d20d65362a6c7e8c24bfd14735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43371365170a94925418374bae3a9882a94fc3995ca1bfabd7e14f7fd7ab5437"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/falcosecurity/falcoctl/cmd/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.buildDate=#{time.iso8601}
      -X #{pkg}.gitCommit=#{tap.user}
      -X #{pkg}.semVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"falcoctl", "completion")
  end

  test do
    system bin/"falcoctl", "tls", "install"
    assert_path_exists testpath/"ca.crt"
    assert_path_exists testpath/"client.crt"

    assert_match version.to_s, shell_output(bin/"falcoctl version")
  end
end
