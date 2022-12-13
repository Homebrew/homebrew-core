class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.4.3.tar.gz"
  sha256 "5b743e45d29f8f71833b33ade8dfb63edd6c726fe63270c0055c6436af17274c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a70d6b2a7d77e43b5b0518c6619a7f2d9fe876682d0feab01cb8ecfaf803133c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e727dc985bf6eea5fd74588ad7528f41ea3e17fc692ab9e051d5db5a366b1d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34e82cb7ced87a33e23476076f2752e87b0c9038759ee1ea3dc2958a214df214"
    sha256 cellar: :any_skip_relocation, ventura:        "d5fcb7a42f028e072246db7b79efc1f1edf19b89893723a4443ae5c9646c13c4"
    sha256 cellar: :any_skip_relocation, monterey:       "016a92798bbb3b10163d8f22605c54da59dec55ca5dccc9afb02932cee495ea0"
    sha256 cellar: :any_skip_relocation, big_sur:        "d48ace1c022874c8903d3c53871296d7ae2c863c975d8072ffee910e3c7a40e9"
    sha256 cellar: :any_skip_relocation, catalina:       "402d5d45547fc2e9c4f097d62ce13671f2944b93f410a8e080f24e018028a1e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1accc24ff85c8779e353f1380bb8597c9d2d083058e18005dd1339a844c9adc"
  end

  depends_on "go" => :build

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"goctl"), "goctl.go"
    end

    generate_completions_from_executable(bin/"goctl", "completion")
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}/goctl --version")
    system bin/"goctl", "template", "init", "--home=#{testpath}/goctl-tpl-#{version}"
    assert_predicate testpath/"goctl-tpl-#{version}", :exist?, "goctl install fail"
  end
end
