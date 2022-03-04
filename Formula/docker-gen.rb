class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/jwilder/docker-gen"
  url "https://github.com/jwilder/docker-gen/archive/0.8.3.tar.gz"
  sha256 "4cc9a007030e147f532980b230eaaf13c8f74e956e6f04c7616c9c735255560a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e670b38ee0bf43c75b43b0ad6e2416acf29af2fea19782d31c513e73b31e4b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff15a3f0cde3c608f89e86020045dbe47a38c82ed2078a760208b78cbc0e663f"
    sha256 cellar: :any_skip_relocation, monterey:       "807f968afc90f52297ac1bb6953b87631a829dbccbe63ae418968c15f3d3dd11"
    sha256 cellar: :any_skip_relocation, big_sur:        "cca0a7a05288e3c4da58f0ce21dacd2cf8ecc0252d38e6052c1ef064f9c7cf6d"
    sha256 cellar: :any_skip_relocation, catalina:       "10b4fe71565f1feff2bc50a1109cc01c6d569f9888ad337464fa06faa7b9f0eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2669fff11633b691ec14c68ef203116fb7259bd93cfd68e91335b4b83638e95f"
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
