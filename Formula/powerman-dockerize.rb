class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "ada4a61a647983cefe180561d2f20563d8109af5b4b5d8d97ee5f90f481ecd15"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1082504a73ad59c91c06ab7c1810305093c4c3355d830975e9e629323b32ccc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41ed975b107390bd1e86c31810cfcc90bb58f0c9f3e52c3697e459a3c098b416"
    sha256 cellar: :any_skip_relocation, monterey:       "93ce069145e85df1c54c2808a6f8d497210a932883f63fbd18991016b8694194"
    sha256 cellar: :any_skip_relocation, big_sur:        "eff21126c46265f95ced315dfd9bf641ae8ed305039ab16be515f5a6b7ffe3df"
    sha256 cellar: :any_skip_relocation, catalina:       "87102cb54c0f4ac8c078956949c2a0155c181c2053cce883eccb4af09057350a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db4844f1bcc009b1fc81d07cd834755ddf48c60552d68dfa0f8c68d8202ca9b5"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w -X main.ver=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system "#{bin}/dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
