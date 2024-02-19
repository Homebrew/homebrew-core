class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.6.2.tar.gz"
  sha256 "a91a8f5368eb8fe31490177d465cee9b30dc631794624be941f8892056dc18c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b64ba3fc7ba707862f13613a106f0eca7de86dac7fe09a6a219b47b02568460"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "267dbc8e6f0f19e7eaebd606346f2ec856b9b9e83581b8f35cfdb964895764a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28d7cc3572eeb5e931816303974f1ab074748ba3f8d24e92942c7abceb1aaf10"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ff98a54f54bbc2fe6c8a6fc26d106c5c5522352cd00f687f815ae034c19925d"
    sha256 cellar: :any_skip_relocation, ventura:        "b2a748a68db1147e9c0d64a11b7dc335e5c6e082a106710bff638ebd871c6df7"
    sha256 cellar: :any_skip_relocation, monterey:       "67a29d84e99c3b99fd4d7878c983cffd704c5d58442328ae157f94a922ef80a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b9d6eeb5b0af1fde173a6c4086153de2d76c85ed2ad5901b6f13db9aeb2120e"
  end

  depends_on "go" => :build

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "goctl.go"
    end

    generate_completions_from_executable(bin/"goctl", "completion")
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}/goctl --version")
    # configure project path
    %w[api model rpc docker kube mongo newapi gateway].each do |f|
      mkdir_p testpath/"#{version}/#{f}"
    end
    system bin/"goctl", "template", "init", "--home=#{testpath}"
    assert_predicate testpath/"api/main.tpl", :exist?, "goctl install fail"
  end
end
