class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "3211c0a20919173152da5d06753826dcc9cc23dfb75a761488de542c0a04161e"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    manifest_sha256 "3aa54bf4192640d88a8088deb53555750d3a79cb6d3a8b71d6f3b99ee5c80d70"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8bee2ba862bb15d249c7722900ec75bcc04c2ede554ec3ed73c6b32b72cdd8c7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8bee2ba862bb15d249c7722900ec75bcc04c2ede554ec3ed73c6b32b72cdd8c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8bee2ba862bb15d249c7722900ec75bcc04c2ede554ec3ed73c6b32b72cdd8c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b019ba54b0d981639d27e671983a0ad0b96c3d85f6806842fb1abe9df654944b"
    sha256 cellar: :any,                 x86_64_linux:      "8c19c6d0966960b6ac2921fdf9df56c03bd6ef0e68cb3441b0704175af760320"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/digitalocean/doctl.Major=#{version.major}
      -X github.com/digitalocean/doctl.Minor=#{version.minor}
      -X github.com/digitalocean/doctl.Patch=#{version.patch}
      -X github.com/digitalocean/doctl.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
