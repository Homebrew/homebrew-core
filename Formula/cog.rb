class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://github.com/replicate/cog"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "53118376c1ddb19d9c4ce866d2b2ebc4bd3899a803268fac0c1e534c23b75843"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

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
