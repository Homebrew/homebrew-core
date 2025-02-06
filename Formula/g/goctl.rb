class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.7.6.tar.gz"
  sha256 "1e06959e58d42b94c04260409a82ec29c56d25890d41ff8e95700fda0913f12c"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{^tools/goctl/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "346ef97064156677b060804941f06affb3513f1e41815a2683311b50f53f27ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "346ef97064156677b060804941f06affb3513f1e41815a2683311b50f53f27ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "346ef97064156677b060804941f06affb3513f1e41815a2683311b50f53f27ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a240cf2114d726b23f76369a63e3210325973119142f28a421c2eec6846acc1"
    sha256 cellar: :any_skip_relocation, ventura:       "2a240cf2114d726b23f76369a63e3210325973119142f28a421c2eec6846acc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a9d20a313cb09bfbce54e40619e73ed0761e5e11bc7277f476dd90e0dd8a480"
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
