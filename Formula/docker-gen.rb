class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/0.9.2.tar.gz"
  sha256 "420e9fc402ef80c45514489b514d58d294bbe0bcacbf58cf02cbf8935f1e5050"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "079e181fba60bb23fa7be90e395efe7aaeac905b0dc695092f494f8df8e24e05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab051c89b15e483b6b7746006cf26bd13d22adc3f360d472dc762dfa433c40d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64ef3dd0358d5cb6338b24627779531ff9c5ae0d9d6db3911fc38c4b97920814"
    sha256 cellar: :any_skip_relocation, ventura:        "11ff3b95f0ea8d09cb67594adda1f4cac043da21aee9e55f729d695eb426b292"
    sha256 cellar: :any_skip_relocation, monterey:       "620396df7b68dee55cff0c30d527aae811d462cfe07e11b0d0948953365ea428"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c92c3453ac07ee874d9fcc567e4bcd59effd285d666131dd3ed29e1b85b6ab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bccd92a0a654ab585f235192ee0d9ce1f907bdaa7c2a5fa84063e61b0b479ef"
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
