class Cozyhr < Formula
  desc "Cozy wrapper around Helm and Flux CD for local development"
  homepage "https://github.com/cozystack/cozyhr"
  url "https://github.com/cozystack/cozyhr/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "2b93668c7c24ebdc0588ca15e7821de77879b883c263f2d295fba41fb9b1c05c"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozyhr.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"cozyhr", "completion")
  end

  test do
    assert_match "cozyhr version #{version}", shell_output("#{bin}/cozyhr --version")
  end
end
