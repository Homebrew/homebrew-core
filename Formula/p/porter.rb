class Porter < Formula
  desc "App artifacts, tools, configs, and logic packaged as distributable installer"
  homepage "https://porter.sh"
  url "https://github.com/getporter/porter/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "927c88d7342439594b4f416f6d18d116afd2418bc48876efedeb1cc8e4716fda"
  license "Apache-2.0"
  head "https://github.com/getporter/porter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bbb8d0fec75d619cb3157967dc5673647c69e2e2abddb4f6ce311ef12bbabfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bbb8d0fec75d619cb3157967dc5673647c69e2e2abddb4f6ce311ef12bbabfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bbb8d0fec75d619cb3157967dc5673647c69e2e2abddb4f6ce311ef12bbabfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f58637b322064fd390d0832cacc06c14eaad6c6d630b352344bd44bd43067f1e"
    sha256 cellar: :any_skip_relocation, ventura:       "f58637b322064fd390d0832cacc06c14eaad6c6d630b352344bd44bd43067f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01040892418ef902c033e9d4504661445774151d63e6f91417ba2a9c0cf4897d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X get.porter.sh/porter/pkg.Version=#{version}
      -X get.porter.sh/porter/pkg.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/porter"
    generate_completions_from_executable(bin/"porter", "completion")
  end

  test do
    assert_match "porter #{version}", shell_output("#{bin}/porter --version")

    system bin/"porter", "create"
    assert_path_exists testpath/"porter.yaml"
  end
end
