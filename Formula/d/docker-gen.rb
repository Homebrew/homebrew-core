class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.17.2.tar.gz"
  sha256 "dfea32f45e8b3f0c61f93927375d538de6bb94c2089b0fb4adbbbce3289df378"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e26612f4c00564bde9145c6f571b25a23af2beeeb09b7ea6dc56be98db3bd69f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e26612f4c00564bde9145c6f571b25a23af2beeeb09b7ea6dc56be98db3bd69f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e26612f4c00564bde9145c6f571b25a23af2beeeb09b7ea6dc56be98db3bd69f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5354c4a97e7c8ac8ce8c08aee51cb556153e60b4b2897ba86e9c09d552fdb43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bcbb7cdfe7534c6827b44e9e2b07bc1ac28f3543f8c648a678b5692c3039034"
    sha256 cellar: :any,                 x86_64_linux:  "e3a0a26d527a2ab7033d8e401389637931e153fdcdd711563f9df77d8c9f81f7"
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
