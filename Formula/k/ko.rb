class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://ko.build"
  url "https://github.com/ko-build/ko/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "4ecd13e513924f16af61f7c3713b989aad8eb10d993ec22c23ea50fe96e32289"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "015166e3fc6af91fa3f0b526fdceab814e5dfe53fabfdca2e0263b442d311ad4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11f581be3a08abea832e7f4600a61a91726a2d0ee28c68068a2f81e8f260f22a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "457627cd2ba7e65bd9668406e1f5b1c32f35764dbb402bb005309a82e687ee58"
    sha256 cellar: :any_skip_relocation, sonoma:         "fec8f3c96c3acbdba2461ba832ca26a9e03e31ec5210d0c1223f98ea8eacea18"
    sha256 cellar: :any_skip_relocation, ventura:        "166f6ad5f1c98d8c07b426240591ec86e09cd375fde49be86b277ba9c84dba18"
    sha256 cellar: :any_skip_relocation, monterey:       "f17af88550f3ea8e463392563d4f654d512e721dba93d9242c61367a7acf8347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42f06bbf81ee9b83f3a1c7c66db1ac4349a9301494f7cba0ef9486b7e7eed313"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}")

    generate_completions_from_executable(bin/"ko", "completion")
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output
  end
end
