class Frizbee < Formula
  desc "Throw a tag at and it comes back with a checksum"
  homepage "https://github.com/stacklok/frizbee"
  url "https://github.com/stacklok/frizbee/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "d3105f8788ab9c0f58ea641c6350c9dd11f34038d18c3785cf79515a8822e085"
  license "Apache-2.0"
  head "https://github.com/stacklok/frizbee.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee21e5891f0587fa9e6261a8f12c02914657b2cdd99aa3728d6bf3c4167b7136"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee21e5891f0587fa9e6261a8f12c02914657b2cdd99aa3728d6bf3c4167b7136"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee21e5891f0587fa9e6261a8f12c02914657b2cdd99aa3728d6bf3c4167b7136"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b0ff2455c9755eb52f40f45d80e9c8646deb6e207f246d2b0e70dfbd6b28347"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33f2b17f4bdc8611c92ca92bd6beaf5c095b2fe22d7a7a572ea6557aa334b854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6491608529728bdb8b9c613582b25c897509c363a1c6b0f3925cd4e50b14f978"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/stacklok/frizbee/internal/cli.CLIVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"frizbee", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frizbee version 2>&1")

    output = shell_output("#{bin}/frizbee actions $(brew --repository)/.github/workflows/tests.yml 2>&1")
    assert_match "Processed: tests.yml", output
  end
end
