class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.8.3.tar.gz"
  sha256 "23edac389dd2ece8b2134405d52f829ca9ec02d33c716219572942b47950815c"
  license "MIT"
  head "https://github.com/zeromicro/go-zero.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^tools/goctl/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bc7cfd7b3755f677a095d14dc40de0e6328eb250b19da1ae7ae2fd3c263e6a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83bfdaba05664339a9f50e93ad308f6d5e8751aee58044eed291beb4a252e432"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ed2e8e7af8a7d4d865adf66b480b7c805c8582bbe8c829a00e3e97d19680cc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "141b1b2e56162c98153452a5772d692fdf7508214949fd897b06fef56fc64f34"
    sha256 cellar: :any_skip_relocation, ventura:       "35a29359853c6d94daaa2b94fae9ec7a2a32915bc331b6bc01b9d720cb45b5e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01d8a1e14789b57b34c19a4b5f4697590ae02d438c0c80d1616a058dd7d6f2e6"
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
    assert_path_exists testpath/"api/main.tpl", "goctl install fail"
  end
end
