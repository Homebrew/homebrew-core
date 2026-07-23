class PrivatebinCli < Formula
  desc "CLI for creating and managing PrivateBin pastes"
  homepage "https://github.com/gearnode/privatebin"
  url "https://github.com/gearnode/privatebin/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "cf11851f5e76d7b8d2b90dd662eb0a3dd03cd71f10cad01fb2f81ecf23d303b2"
  license "ISC"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf4f261b7a6b91ce1d1ea15257b2e533dd47b4e9a7d635c2d9985c033698c48a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf4f261b7a6b91ce1d1ea15257b2e533dd47b4e9a7d635c2d9985c033698c48a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf4f261b7a6b91ce1d1ea15257b2e533dd47b4e9a7d635c2d9985c033698c48a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ca7892ee44e534bf0e81e50f9a9ea2ab79bb1335aa805d86b67cb68ad40a83b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97b0c6526605a3ec8bf164a9805bd4e7806c5d78bfe69c7211561abc719f511c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f23a8f66a69a556b63317ad2d4659062601b3518e9c782ce090db5a6486f8a5c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"privatebin"), "./cmd/privatebin"

    generate_completions_from_executable(bin/"privatebin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/privatebin --version")

    assert_match "Error: no privatebin instance configured", shell_output("#{bin}/privatebin create foo 2>&1", 1)
  end
end
