class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize/archive/refs/tags/v0.16.5.tar.gz"
  sha256 "1e95dd049ba6647ad10b1744bd5fa9e80239698b20950bce2a0e3c67b563fe05"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d90c7cd879e9a9b4f64530cb47a9509e8671a7634bffb7a31a0928e7e712031f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72a12caea93fcd605a9b381054c6fe6f9b5a8018d8153453b57a13efc15eaf3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "746bf3f595691c84e74d1fdf4244d37bd470934c19c76d3c46d92b1a35b711e9"
    sha256 cellar: :any_skip_relocation, monterey:       "0dae012f0937d8e235148357cfc99ae528a7a98ebbf620708eeeaa1848793efb"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb7b2fd54adb8ce7aef4a0e0359bcdc31b1d87d26d465c18b69df5e688e79642"
    sha256 cellar: :any_skip_relocation, catalina:       "003d122471bf4b623dfb39a88d28b57294d215de8610d6ba1b2237118ba9f32f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "097da0cffba33324a84ee6e3792c8b0ae58bdb24bfc836eecfa0b541c6f05037"
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
