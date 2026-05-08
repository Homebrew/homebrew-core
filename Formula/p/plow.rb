class Plow < Formula
  desc "High-performance and real-time metrics displaying HTTP benchmarking tool"
  homepage "https://github.com/six-ddc/plow"
  url "https://github.com/six-ddc/plow/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "e1b706c8aa137a09dc4061bd9a01c12ad8bb8e175d28d6180008a2a296349d91"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76b61faa69be42c37f53cdb1858edd3a9041281e5d97c01b594cf9a672f2ca59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76b61faa69be42c37f53cdb1858edd3a9041281e5d97c01b594cf9a672f2ca59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76b61faa69be42c37f53cdb1858edd3a9041281e5d97c01b594cf9a672f2ca59"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f65155edecaa6cf827a60b4c487b8de72446dd7291458b3cb21736064d5c4d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c77bec73d49957c37b155150ab183d637b842d1f6fdc901e2af44ddcf5ecfbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "857ac84c99e42acfb4d6d86058e8df9691a7f0685d639003968e75192fcee167"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"plow", shell_parameter_format: "--completion-script-",
                                                     shells:                 [:bash, :zsh])
  end

  test do
    output = "2xx"
    assert_match output.to_s, shell_output("#{bin}/plow -n 1 https://httpbin.org/get")

    assert_match version.to_s, shell_output("#{bin}/plow --version")
  end
end
