class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/jwilder/docker-gen"
  url "https://github.com/jwilder/docker-gen/archive/0.8.4.tar.gz"
  sha256 "5aa3f69f365a1f2120e70bd74cb29153a5a148181856d832f06179052e0d8646"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "408fb3592fb71371481318218eb6f8fb64f05924f513e301d897bbec1e1aec13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6fadfd741b5e5b06e760af0c3f9b711fecd0ec53610ea639e667377da4a2f1ad"
    sha256 cellar: :any_skip_relocation, monterey:       "318aa607e0417f547ee760c47fb349327aab3a3a58cfffc6548e83f78096ec0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa5e3021c6c7edb85cbff0ff22037233fcbb7d7fc65f8f5af503e98c361fb897"
    sha256 cellar: :any_skip_relocation, catalina:       "e1977bae64bda60dab0c44bebabb18049291a7b12188e194585e0c5b077262ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce485d524315f8564b5d86d5523b6835e105660f78debf9c3414d13131423eab"
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
