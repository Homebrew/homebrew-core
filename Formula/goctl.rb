class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.3.7.tar.gz"
  sha256 "a1929aa2c4d518d89cac2ee085bc59d0e6a3d037ee3923eeea01524751154baa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "548ba4fbcccaea6c26f20b75a69561b1ea4b1cbd4986a09ae273f83514e10a4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fd4b4776b392a65cb4feac19a4128aab9dfc8a54459f40f7f7a195e859b43fa"
    sha256 cellar: :any_skip_relocation, monterey:       "344ef672f52d5a33f97abe53ced1eb34893829fcca9052d01e81b1cb0900e29e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9f953fd66c4370b843fd4460637e42342b7cd5f811510c51c73cd358f910b26"
    sha256 cellar: :any_skip_relocation, catalina:       "2bc274214d7979fc04de89b5803d3a8d125b6edf40b7b31eef6363e768f42e36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b84ce26bb0ca0d5da04540bd55d451a5f140ce9e20dbbb3f168e04ff014d87d"
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
