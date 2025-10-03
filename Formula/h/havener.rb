class Havener < Formula
  desc "Swiss army knife for Kubernetes tasks"
  homepage "https://github.com/homeport/havener"
  url "https://github.com/homeport/havener/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "f5fe8bc809694bd8c757c3ddaac91cdcc20eb9efc988dd736838b0a8bbfdf7e8"
  license "MIT"
  head "https://github.com/homeport/havener.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51ebfb38c43b3da01dc608b82286d22b9196bb781d83302706c9e7fd70e52e38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "782f87dbacbc1f10917ce27d6c55a7b056a79599d8cb278a4177f083f997df94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4d9fa80983fc35b46c5fdf848329e6411f7721fb682c2b7e47f245a18d1284c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7508c64e16751ec9db51a2c3bb20723c81a63d41e1c5f764cd905f80c1f01501"
    sha256 cellar: :any_skip_relocation, sonoma:        "d92ca660499fd2425363e86b2a4e8705d66f6fdca8ecd9d67df608268f5957c3"
    sha256 cellar: :any_skip_relocation, ventura:       "c0c17a5fc1a6da70aa556b4fd99705774d13d1afd2a66e0b027d76177a08b9ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f045d9de94acb50ebf35282493b8111f01e7b94acb8dac684df1b4cc2d2fd1fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b26d282528a406601cfe3abb4d5ad3d5809b0403e00389d6e8736750d35ce419"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/homeport/havener/internal/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/havener"

    generate_completions_from_executable(bin/"havener", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/havener version")

    assert_match "unable to get access to cluster", shell_output("#{bin}/havener events 2>&1", 1)
  end
end
