class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "a4fcd3a9acafc67c8eda1dfc1fd5914e827f4ace4843d97026520903ab37254d"
  license "Apache-2.0"
  head "https://github.com/liqotech/liqo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9c6280ba4a3ba3b82661a88661f39994bb4fac9ab9319d0339e05ab7481f07e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9c6280ba4a3ba3b82661a88661f39994bb4fac9ab9319d0339e05ab7481f07e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9c6280ba4a3ba3b82661a88661f39994bb4fac9ab9319d0339e05ab7481f07e"
    sha256 cellar: :any_skip_relocation, sonoma:        "23f06f1082743735538fd1f7ddc4d601e34b5c058cae015160cb88c7621da610"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "664ca0d313b279b380f7461ecc3679ab47f4495f41fdfdf53d72852e6542a054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4320b23df8b4bbae46d58937314e9d423dbc30d91bef984e5ef57c7e58c29576"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/liqotech/liqo/pkg/liqoctl/version.LiqoctlVersion=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/liqoctl"

    generate_completions_from_executable(bin/"liqoctl", shell_parameter_format: :cobra)
  end

  test do
    run_output = shell_output("#{bin}/liqoctl 2>&1")
    assert_match "liqoctl is a CLI tool to install and manage Liqo.", run_output
    assert_match version.to_s, shell_output("#{bin}/liqoctl version --client")
  end
end
