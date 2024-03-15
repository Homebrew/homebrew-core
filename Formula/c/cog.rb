class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://github.com/replicate/cog"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "e8ed3242f17cfffc6d80841aa46f6b1cf2a0170a3a3488be80cf2a123a56f714"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af923bdf3e61eb935531805f8b57fb18b0a54f6cfbc4fe49e2841275844596f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1d3661b7c94958241ac609798615a96af81241997db42db68687003553b4ea5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31f57813e5fccb45be9aa2fd10180e86abd87c5ce1cb1bbf417f09199fd806e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "14b2612b58b65d70ad8ec2dbb8a88c5df0d08f607da69fa1956f22fb88e77a96"
    sha256 cellar: :any_skip_relocation, ventura:        "f5dc3667506b9e25eac81b3dafb927dedf528dcf12000be3829fc6f97202396f"
    sha256 cellar: :any_skip_relocation, monterey:       "207cd24010feebe42626b1ce1c9b7cef5d6917f3d6a832d41fbba0df6fa12e6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2ec63aeea525235209663458def7b77995d964f3d12cb839c12c86b2f38f523"
  end

  depends_on "go" => :build
  depends_on "python@3.12" => :build

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
    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
    assert_match "cog.yaml not found", shell_output("#{bin}/cog build 2>&1", 1)
  end
end
