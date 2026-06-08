class Cloudfox < Formula
  desc "Automating situational awareness for cloud penetration tests"
  homepage "https://github.com/BishopFox/cloudfox"
  url "https://github.com/BishopFox/cloudfox/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "642f16328c9c9c6673453d44a361172836c542fb8098285b0cf363e5715a2be0"
  license "MIT"
  head "https://github.com/BishopFox/cloudfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8992debbe2a49ca5da78a772f3945a1b35e450bdbdc076cc8bfa3408fd249b34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8992debbe2a49ca5da78a772f3945a1b35e450bdbdc076cc8bfa3408fd249b34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8992debbe2a49ca5da78a772f3945a1b35e450bdbdc076cc8bfa3408fd249b34"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2fac4a4e08d92063ce01d2444938a5d823e01759d3f17a1d4c80c8150ce6c32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "734f21e383ab86b8d78bb81e2f7c5ad2ad03678fcec1c7d23306b236d970e429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28fed77de1d3254b6087337ef3e0311ed8a1af1af39390562a3959a65b09b88d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cloudfox", shell_parameter_format: :cobra)
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}/cloudfox aws principals 2>&1")
    assert_match "Could not get caller's identity", output

    assert_match version.to_s, shell_output("#{bin}/cloudfox --version")
  end
end
