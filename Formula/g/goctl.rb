class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.8.2.tar.gz"
  sha256 "806ba8ddec6228c3b55ad1012ea6721eeb2f22d3e0e847b2b0cf5a51d8f6b9fb"
  license "MIT"
  head "https://github.com/zeromicro/go-zero.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^tools/goctl/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02801883543da7219f8d0e03b6c2040b73480a1f6aed399cd23f4b80334a775f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b76c9bbd72e856cc9b860b5537b8fc56433434c98571146b7b7cbd58f1637a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "598a9b6125e71762ae9e7c7be8aa95b379d2c010c6bb42d8ee7b7778e370455c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f3420d92d996cdb5ea2058a3240b55570e3ac898ce7f768051cd7aed822b9c1"
    sha256 cellar: :any_skip_relocation, ventura:       "0c69e9c9339986a52cc8c15d72e44d0029802b4842272b6fe6ec01c566a28bed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa27a1f392c9fc137a243b745a98cc6dd9b2c41ed3916205e258650f8bd6e033"
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
