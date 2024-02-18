class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://github.com/replicate/cog"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "5f455da636ec6dd6c81fd46fb721e261da1912ec42e2c547496c9cc8bae78773"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e4487f81bba0027b04ebabda2c9e32c3e81cc6a1c14b8f6a65a57462266d838"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd980304b84c5ad3d732e4b025a42a1446394128d83d406e779ab00d92b34d3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c60097dcb7d72346cf6e4e46a49be556655f3f2687200620bccd234d228477f"
    sha256 cellar: :any_skip_relocation, sonoma:         "de636cf99f2f4162f11683a4457f7047d5e2a907a6ed639aa39783cf2a2888b1"
    sha256 cellar: :any_skip_relocation, ventura:        "f526ce33260b4eb2d3686cc72e9ba35cfdd76bd1f9f034baeaeb31daa121eb04"
    sha256 cellar: :any_skip_relocation, monterey:       "8f7b05a97df14e5240ab5684058a44d043763f05f0734ed71bfba21fa7ca1195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19e01d6fdf14ddcd473c6eee30ffbc8f3464a6e444492e0bf3fb434baa7048cd"
  end

  depends_on "go" => :build

  uses_from_macos "python" => :build

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version.to_s
    system "make", "COG_VERSION=#{version}", "PYTHON=python3"
    bin.install "cog"
    generate_completions_from_executable(bin/"cog", "completion")
  end

  test do
    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
    assert_match "cog.yaml not found", shell_output("#{bin}/cog build 2>&1", 1)
  end
end
