class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/jwilder/docker-gen"
  url "https://github.com/jwilder/docker-gen/archive/0.7.7.tar.gz"
  sha256 "12e9b71bad7e5ab18a32b994e96423f9b68df840892db19cbe3a18cba1823d36"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "66b8c1c35b2f64e34d4569758bf6629e4d810176c91fcd85522b9d7c190694c5"
    sha256 cellar: :any_skip_relocation, big_sur:       "68fe85441e755d75d01d2f897ff47a50a55c00eeda1f9ec8f9d26bdde1005be3"
    sha256 cellar: :any_skip_relocation, catalina:      "084de82737d60acf60f584fc4f8ad684a112a92e825ac8fa0aeefad61e987b8d"
    sha256 cellar: :any_skip_relocation, mojave:        "ab933d1006253f737c39cdd625ce4b31c5e2b0df3779ed69f104ff1edec36d77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb5c8240bd6614dcdf3c84693ae65bb7a0fd5e4527fec2e496de240bd9068ffe"
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
