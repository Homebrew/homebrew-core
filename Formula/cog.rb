class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://github.com/replicate/cog"
  url "https://github.com/replicate/cog.git",
      tag:      "v0.5.1",
      revision: "b58bd63e3cd9b7db0a3410ef47c61c1b11255809"
  license "Apache-2.0"

  head "https://github.com/replicate/cog.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build
  depends_on "python@3.10" => :build
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
  end
end
