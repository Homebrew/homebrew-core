class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://github.com/replicate/cog"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "0cddc2fb36a3a9c96ec94c0199e637a165eee3c86c6ab8cd6c3555cd3ae4c129"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff8588765fb0e57e3189a43617988660b2af8c4a4f7e0e5e998d021254f77f33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69aa7f3a73761f4e781c897cc44201879b97a95de5ee5f3f200bccf5c03f798e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "266813340a64964de830f11e596c0e29410a7a3b275da99c8977c633f7cb4b43"
    sha256 cellar: :any_skip_relocation, ventura:        "8893805247faa2744b7d0a17ef822bbaba590d76cd306adaa6031933182955ba"
    sha256 cellar: :any_skip_relocation, monterey:       "b436dbac9b7056f6dd058f8e1dd02111d2dbcc19cf10b74a708eddfe328a0e21"
    sha256 cellar: :any_skip_relocation, big_sur:        "98191db0eb6f8523b8bb2779bc8beba4230e5b4829d167000d79f04f0f687eda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9469910c1f95d07aa6184d8a77e7f0e0e9a513b97a3e92dedc28dae4d0a821a7"
  end

  depends_on "go" => :build
  depends_on "python@3.11" => :build
  depends_on "redis"

  def install
    args = %W[
      COG_VERSION=#{version}
      PYTHON=python3
    ]

    system "make", *args
    bin.install "cog"

    generate_completions_from_executable(bin/"cog", "completion")
  end

  test do
    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
    assert_match "cog.yaml not found", shell_output("#{bin}/cog build 2>&1", 1)
  end
end
