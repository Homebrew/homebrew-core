class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/jwilder/docker-gen"
  url "https://github.com/jwilder/docker-gen/archive/0.8.4.tar.gz"
  sha256 "5aa3f69f365a1f2120e70bd74cb29153a5a148181856d832f06179052e0d8646"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e88c7e2a6b51893a39c2e0d952746d1c9f7870063839c5cacbbbaf771e304a42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8aefc8f208ed87db3c948f57eebdf5e11aedd67f86c8dd54fbc3f64149c9182"
    sha256 cellar: :any_skip_relocation, monterey:       "ba57d8f480799a37d6a0445e8fe1a3976dbbe6d1772b437f5ff775be601673c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d63f28cca9ef8820cfd6c6111e0bf5c28f7343e33bb2049cd9a4fbaf75addf97"
    sha256 cellar: :any_skip_relocation, catalina:       "342c503ffb4ee5e8a2722148ea3ac48555f84cae55cd4da9e1c73acd01ffd568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbb25452a6a7451c198ee3d3fb37a265e4135adda85e87b23e0754ad351b757a"
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
