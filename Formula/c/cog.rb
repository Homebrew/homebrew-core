class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.9.15.tar.gz"
  sha256 "ebdb94c4bd28ae4f8a1538c0c173a1b7a9a6fff81ee21d8257f33e4b0dccae65"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b711b2e6e3a27f86bda74ce9bfd96dccf1fc0b3b5c5d7997b5110cebd14cf5b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cffb8eccf2b820e31451991a5216ac49368478434f6aa08186d3f30610ce3394"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c157f06452b6df10c3d3375a876043f0f850c152d41d9fbe85da32265ee467bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3bad40e2f98bf6c7feeb971711f47042cbe62d5674931e0391d56a38e14377c"
    sha256 cellar: :any_skip_relocation, ventura:        "219b96e5cd241edd4a31c619bf39254f9ff9f7316a34a24084b4ccd4b86259d3"
    sha256 cellar: :any_skip_relocation, monterey:       "a2383447a8b64fbec1b4653902eb456e4d4d520f790215cc8acc572ce68fd9db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e39cd2a27ddb9d2239715a1ba7719d3618449a4923afdf2d297f1002793fc7be"
  end

  depends_on "go" => :build
  depends_on "python@3.12" => :build

  conflicts_with "cocogitto", because: "both install `cog` binaries"

  def install
    python3 = "python3.12"

    # Prevent Makefile from running `pip install build` by manually creating wheel.
    # Otherwise it can end up installing binary wheels.
    system python3, "-m", "pip", "wheel", "--verbose", "--no-deps", "--no-binary=:all:", "."
    (buildpath/"pkg/dockerfile/embed").install buildpath.glob("cog-*.whl").first => "cog.whl"

    system "make", "install", "COG_VERSION=#{version}", "PYTHON=#{python3}", "PREFIX=#{prefix}"
    generate_completions_from_executable(bin/"cog", "completion")
  end

  test do
    assert_match "Failed to ping docker", shell_output("#{bin}/cog build 2>&1", 1)
    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
  end
end
