class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.4.1.tar.gz"
  sha256 "019cbb71d900903656282e448fca8ffa45b6288a3f50e7295b5a4cd68ab0a3f0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae5cfe0eb8f7342a4bc9864e64f395b92a1f9b65944c92f137d6a3e9a842480a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b93798d7676f0cbcd9de23cf0edfeaf969de379009f4f55ad89b853990045331"
    sha256 cellar: :any_skip_relocation, monterey:       "ee2a313e1410b20d0d178c133e0443dc6ac3614939d8b4fc8278af3c613f6b97"
    sha256 cellar: :any_skip_relocation, big_sur:        "9073f16a120692ada5f2930c00bb4f4c440a194b7b2c4c717962e96c44f1f01a"
    sha256 cellar: :any_skip_relocation, catalina:       "18098826432916e7da3f59065a9c6826fdbf5a4a940aad3a769086e2e36f78ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f96a062ba1579e75f9d06f4b4c0f9f32201ec73d0ef6861d0de17cd7dbe8664b"
  end

  depends_on "go" => :build

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"goctl"), "goctl.go"
    end
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}/goctl --version")
    system bin/"goctl", "template", "init", "--home=#{testpath}/goctl-tpl-#{version}"
    assert_predicate testpath/"goctl-tpl-#{version}", :exist?, "goctl install fail"
  end
end
