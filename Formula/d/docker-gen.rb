class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.11.2.tar.gz"
  sha256 "d8e93fa8d3952a31067b9e4fb3a8324057e4ddf55b0d8427436d536c28932b18"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82113a47907409b7c4f176897256b5e24d46ef70b0578ebf68506c94c4f27b8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c15650495d06995cf82a5ff7a68fb48bc7bb50ece16a6e4aafbec2cd307c86b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e535ee59a46cec09f30a04d9159be161dc7fad60a4058a57634c2e944270eefc"
    sha256 cellar: :any_skip_relocation, sonoma:         "4673533d87c4aa295dbe7c8cedd63beb0a9294f8df1a7641b1b5556e994f69e7"
    sha256 cellar: :any_skip_relocation, ventura:        "a082ee5312d80f7e61dca57427d39df36e1043b287c1cad8614a0317187f07b9"
    sha256 cellar: :any_skip_relocation, monterey:       "83b9c00c282232b41e7e73735e97fc19cbff1c4fecc6d5392fe79e18a6b7502d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ff9b66389eed5dd6424a0e42bac56b829f745fbc303a8675b92bb2dffdbc44f"
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
