class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/refs/tags/v0.8.44.tar.gz"
  sha256 "47259943e25be8d5b98e70188e34412451d523b1c100b0d214b0c714d398dece"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/ctlptl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72662a0048e6407fc05e219b1d62b371e796db438dd2a3de7ae899d92eaf0cc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2f3d3b470598c93210c4fcbb5b76b37617d7e33093c8dbe6e384b68af613d90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06306bb8bbd76a8583aae8a4fecc341e5a337a0d973109cbe4d8fd21a692dfc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad043d5275a8cc7acdf8aca4b04a1bdcc1a1a7b78fbf695ec952cab2dc0612ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0875e166067afa21514d29d3f6b7bd1a71e10bacd6c3bbe1ab7d7095876df6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e17e64ccfc23bd4f0b50af0f2a56f493dadf85d3c714bec44739d96bfae8dbc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_empty shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
