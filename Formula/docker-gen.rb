class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/jwilder/docker-gen"
  url "https://github.com/jwilder/docker-gen/archive/0.7.6.tar.gz"
  sha256 "6fa4aa083b21636250a0067f9365be8c739bd56f85fdbb612dbf37578be68d1f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fc7b2d7b22a62b6dc5fb591e34ae7dbc552057e23814f2c2ae47d7d3448bf2da"
    sha256 cellar: :any_skip_relocation, big_sur:       "df088bb6b0762746c6b472ffceafc527aa37ed606518746e12d27a935a353a9c"
    sha256 cellar: :any_skip_relocation, catalina:      "d0f8f4eaccd1c001ca1c56c66bb554678432296ee1097862d117c9cef4f83087"
    sha256 cellar: :any_skip_relocation, mojave:        "374691a880904b97fc9dc925ff2fcedaba98a64234cf43a1ef0957b3d535b9cd"
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
