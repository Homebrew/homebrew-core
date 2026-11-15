class Porter < Formula
  desc "App artifacts, tools, configs, and logic packaged as distributable installer"
  homepage "https://porter.sh"
  url "https://github.com/getporter/porter/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "46856bc287389d8a1bd988e0c3ea2e3f3017ffc7261c8fe7e4c56b33e4008640"
  license "Apache-2.0"
  head "https://github.com/getporter/porter.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6243954ed826a2320e2403e5b0cd125d1faef5fada6b193ee5fc090a289e48ba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9f3c2143f49fa57f9c248e05abb60e7939333e64b942216846d5152cdf69fe4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "87e94d06c86b8daadf3947be9588c75e36b40629793aee7ed48b735ca211934e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "38df4d9b3ce37d3ee4c9f1c946317ceecf0a2039ff7f1cf88bfa563ac703c65b"
    sha256 cellar: :any,                 x86_64_linux:      "e2f184d10fbefe148ef856170b4b0d26428370f45602deb66b256c6f4b050778"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
