class Diffoci < Formula
  desc "Diff for Docker and OCI container images"
  homepage "https://github.com/reproducible-containers/diffoci"
  url "https://github.com/reproducible-containers/diffoci/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "86ff1f7d0a91934790369184fa88b5402c5b7b0ec87358c915b2fb1e97bd5c0d"
  license "Apache-2.0"
  head "https://github.com/reproducible-containers/diffoci.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aca47f46cdc012e3cff9a39adf72d76057c64f52b5b7a0568ef186dcdab5e69f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aca47f46cdc012e3cff9a39adf72d76057c64f52b5b7a0568ef186dcdab5e69f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aca47f46cdc012e3cff9a39adf72d76057c64f52b5b7a0568ef186dcdab5e69f"
    sha256 cellar: :any_skip_relocation, sonoma:        "605a4b38e7d29b2c72fbdf09056567e7f2ea2deeab6b9570c895cc49f1dec17e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49d38dce7132e1b7e4a565766f3ef9511cf8c707168a9b71fec42db83523acf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6595788a1588d276c8345fcf30217ba5f2e0d1ae97ca6f07410a8c0749d4dab3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/reproducible-containers/diffoci/cmd/diffoci/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/diffoci"

    generate_completions_from_executable(bin/"diffoci", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Backend: local", shell_output("#{bin}/diffoci info")

    assert_match version.to_s, shell_output("#{bin}/diffoci --version")
  end
end
