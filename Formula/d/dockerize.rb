class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "e87dadb9537f5e33cd819d2fbe3344b41b91cf83bf8fee2a3c2c5e08fdac43f7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "81c07f4f6c963011a0645c7fe3cf93d8de34931dccf93f2c16157d0f7c352e3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8136ba1df7b4ea718f7abdcfe5f7bc2213ae359c3119b5bb405130c4c20ebb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e109bc1300311ea26c2c71eb4b1ac20a66a3355ef0fcdfe3df037cd40aef539"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ab9433de7d68ea6f313ffe78872dadd1cf3023f248cf8161db391dc335e8a3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "dac9c34074a1dfa813b3d666cd52468a02075888c83abbf8ed195e01795057cc"
    sha256 cellar: :any_skip_relocation, ventura:        "012a755e03ab2f2cd2e0ddc9193fbdc4bb9b10642b9129af782d9f37f17fbec0"
    sha256 cellar: :any_skip_relocation, monterey:       "85edf73e326216f09d8ac7e3f1f59861e31a59d883f2ad82639a79f40995f3f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f51ceb70ec23da4a4385d0dbf9aabec31c13c25dd3929bc00b12e7e55860de9b"
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
