class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://github.com/replicate/cog"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "75e7fc14d08a747fb497ae12e0879f2e39fe7bcd369d4c4814b7b58dd28c44f5"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e2bcaa010a1a61a65739c01f0e625d9fbb871c64f2215f1700fdf031b9ae8e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbdf67c47c332873ebe5b39dcd4c2caab19b07767e9c6edbb9170faeaeb7ed88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52af71a0d8c09559e6f63de9a8684c3072a7aa87649d6be66545a34c013189af"
    sha256 cellar: :any_skip_relocation, ventura:        "c3de82ac657054c3c82bca0dde89d676bcf13643fc786084c2f9e20c754c31c2"
    sha256 cellar: :any_skip_relocation, monterey:       "2d970eb87637470181bcee0df4cef9e20a4b3f691e3f869e93b1517832cd8903"
    sha256 cellar: :any_skip_relocation, big_sur:        "1021afd55c99c87ceec5b93e3fd96f01e713af3029d228fa35192c79cf5c5517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1121cf2c740d4afc1cca308271e6c525ebdf69f00c95bb3d4dbf812108cf4bf0"
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
