class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.11.1.tar.gz"
  sha256 "b957fef090a085c0ed30a748af1825acf5d4ac044af4079d198f69633b6375ac"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4faa6b7d1981f62515e0a773e48b358497f1dc652de20d7a2d1762dcdc70cb0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e08b69b801d78e76d70938971e13647bd459840c926aa44895ef7a603ba871f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a8c22a8b31ee6fb6fb8d7a4a73f1fb1c5b3b9617d81017853b6c438dad87caa"
    sha256 cellar: :any_skip_relocation, sonoma:         "b52940bb20c2b9c04015c5b36bc4aacfba0731a6d335f2a2950824089e513d8e"
    sha256 cellar: :any_skip_relocation, ventura:        "869b15287ad267e6f2bfd298f645febaf425fde2436cfb2046a924597081f545"
    sha256 cellar: :any_skip_relocation, monterey:       "53121cac2b4ac6c1388128dd708d5b894aaaf8d92832a978a230250dd5c57374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8f0ec50a4034d1cf3718ea9b24b91e3bdc706751f8564b6c726691a60c1a902"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
