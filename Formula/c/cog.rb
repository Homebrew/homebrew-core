class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "e3cadf1703f4566fe954bf310786796be5cd9b6c8ce91a71cb7fec9f7538a39f"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb996412e3fb53b514b9252b8af9b0e235795d0c084ca5ce4c445a4199836cc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b62ed032632d1845638e445e96b7ffff38dd44f4a17786b7d6baa9904a9c1f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "490caa1ac61e1ecfa8bc0296a9d0db0f7b008ba2d48db57f2f108c39d79533de"
    sha256 cellar: :any_skip_relocation, sonoma:         "dcee830514fbeac1481eff8146a9b271647e8acc9a4d6d7ced5d5816b7901523"
    sha256 cellar: :any_skip_relocation, ventura:        "08c026434525def60b8bc21a63d21d8855db06ed0acd532539489e21dea73ed9"
    sha256 cellar: :any_skip_relocation, monterey:       "99bbfec6d5a5287ef127a96e463c0c90a7e5827896ea9d4bc5f118628bc59ccd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df596321306a74a8b61e1a47d884d03f58d84f427eb9dee124b6830f5afabfaa"
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
