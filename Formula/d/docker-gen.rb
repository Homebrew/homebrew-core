class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.14.0.tar.gz"
  sha256 "3b8c6045a7657207c255d0353fff79d8966f0c7709f1b53800e851631bfab7c0"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff395d6e000256f8fc79b89f39255e5429c4025af50a811d495207496c3d159e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fc1bbd4a9ed2ad09319c75fd52685bf1e6cc9148ecd5b6ec0fc50ed6abb074c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83b5b0b4e99e6ab62415044fd2ef9f6f8fdf5d77df7f35d17bb39b998a524787"
    sha256 cellar: :any_skip_relocation, sonoma:         "4eff833ac1031bf8a44c2f7256e7719e97c4e43cd27eaaca7dce7980c8d73010"
    sha256 cellar: :any_skip_relocation, ventura:        "62c337bdd313bea7b72d9b1aaf7e7474c6c34c748f34b36e3451594ef4662c1d"
    sha256 cellar: :any_skip_relocation, monterey:       "f2fa17683673173756d4ae113f52cb24f348a6c2fbfeec488ad6c14faa81c5b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3fdebe391cc3dcbf4c2f04d5086a3798ff38f3e07abbcae74e4fadcc9714460"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
