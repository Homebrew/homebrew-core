class Defang < Formula
  desc "Command-line interface for the Defang Opinionated Platform"
  homepage "https://defang.io/"
  url "https://github.com/DefangLabs/defang/archive/refs/tags/v3.15.5.tar.gz"
  sha256 "d9e6f57dab85b4f607ae473b31ac6ce749b3571c69a7c2be3805737bd410934a"
  license "MIT"
  head "https://github.com/DefangLabs/defang.git", branch: "main"

  depends_on "go" => :build

  deny_network_access!

  def fetch
    cd "src" do
      system "go", "mod", "download"
    end
  end

  def install
    cd "src" do
      ldflags = "-X main.version=#{version}"
      system "go", "build", *std_go_args(ldflags:), "./cmd/cli"
    end

    generate_completions_from_executable bin/"defang", "completion"
  end

  test do
    assert_match "__start_defang()", shell_output("#{bin}/defang completion bash")
    assert_match version.to_s, shell_output("#{bin}/defang --version")
  end
end
