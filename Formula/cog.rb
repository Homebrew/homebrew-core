class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://github.com/replicate/cog"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "0cddc2fb36a3a9c96ec94c0199e637a165eee3c86c6ab8cd6c3555cd3ae4c129"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d895dfd2655ed76ca075dd0700a08222278ecb0b698209708979edaeaef18eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96ac14d03925ed4b9c5c4a380a3e5d59a7877780e42cf801a2c5513b34978977"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8aa6be1a80f36f312811f84aaa9e13bebd810d6523048538f62a93df212cfa32"
    sha256 cellar: :any_skip_relocation, ventura:        "798bca909811e112f922be599f6063f4c3aac3f44adf845bae52aa59cd29d466"
    sha256 cellar: :any_skip_relocation, monterey:       "0067a5c6a6a2bc73ce64e96fc179c8d0c68d09209028578ffec92d21ded79b0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b6aca7062549fe565ac3319481844c69734d22bfde1bff741b28497673ec3f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e600647ea32135400262943376713ea870550874dad704841e2cbd46134856be"
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
