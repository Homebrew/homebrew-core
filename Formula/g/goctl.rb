class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.7.0.tar.gz"
  sha256 "ec494c7527a9805a5d330df212b2e38b9389c81e9dcb48089c3e6a0ba10beef2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eff0d8be783ebbfc70e9cfa982b3794c81afa6fbac9cf3296c7b160ec8114814"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "773b60e74ab1cd11c5de2548be0e4e1ad95eeb529f0882c193de4a1073f82144"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "965b77b78a4aa367f98e76edc4b65e796e381929c8ce3259f73233709dbc91ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "d480680a046a5a48337a3e8c46f548a4ab11cb3e7e42e5242c93ed6077c44e44"
    sha256 cellar: :any_skip_relocation, ventura:        "60393426ca130260417636dc429c0ecce2c8e4fb7f10c62a2f1c4ef6e518eb53"
    sha256 cellar: :any_skip_relocation, monterey:       "dff21afdc1bbcafc65ab1c0f1aafb6f89c48cd03f5cdcc360ccc5331228fc004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc690a3f6a4b6b7096b4fc14ae9f1c7e2e0d260ccd2634968450703911bb2349"
  end

  depends_on "go" => :build

  # patch go.mod/go.sum, upstream patch PR, https://github.com/zeromicro/go-zero/pull/4279
  patch do
    url "https://github.com/zeromicro/go-zero/commit/481c9e6a604da0bdfaf1a8f383a897ef4b3b7ef2.patch?full_index=1"
    sha256 "8c34eba9e5f423f6c9da9fbe180867b9d71cdf214984c475ab53581d487c901c"
  end

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
