class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.9.0.tar.gz"
  sha256 "e02c2ce3e101e2d0160498c87225d179ec2aa2eaf9967475e5abc3625a324899"
  license "MIT"
  head "https://github.com/zeromicro/go-zero.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^tools/goctl/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14c2d5d54ba935c525d98813531642ce43e79c50e10152ee34d14467e46e30cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ea8ca9f52f2229a8a7591d6782c0f0602a635bf8eee5c5f5e4214386c0e0020"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b07dea1fbc88665820951fccd5cc9dd469f9a454e23aadc2d57c52354ceaf487"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dbe1c3d03175074a9a7a3207fe14e633669b1c2270cd2e71ebbfa8e42fb98257"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d14a4d6b9a1eaeedd78bec7e1d2ca2eb1f9f4e8e59bff6195ba53f472f4d05b"
    sha256 cellar: :any_skip_relocation, ventura:       "8733c51e4b5816e11f143262c2377be3da10137476b9dab65abec566d24ab840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e753b68cac53bd59f1ddaf377523c968a9cc09b0f803b5a26cf96fdefada1bc"
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
