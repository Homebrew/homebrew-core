class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "152d612550d932167a5a4d87dae828a2433222b75fdd02617c0baf907637ccd7"
  license "MIT"
  head "https://github.com/jwilder/dockerize.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22e025a1e437cb4eada2675b1377a106e7c13d6c7d30f8cc5de98fea5844c0e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22e025a1e437cb4eada2675b1377a106e7c13d6c7d30f8cc5de98fea5844c0e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22e025a1e437cb4eada2675b1377a106e7c13d6c7d30f8cc5de98fea5844c0e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe8d0675a5edefa1564d2ecd566824f19baef3b4be3dae955a2051565c9f8e0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a5a7c04bc046ed8d03eb8c9d90266f4cfa7638be708fe9e9189687ca74c4825"
    sha256 cellar: :any,                 x86_64_linux:  "fba1ac8bcd9e25b2cd3964589320d7dde2c68e074fff63bb3ca2ee4a35b341d7"
  end

  depends_on "go" => :build
  conflicts_with "powerman-dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.buildVersion=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
