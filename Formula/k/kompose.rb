class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "92cddf4a1d86e3ec18506e13706bfd0adfa9cb5dcecf362f60bf2affabcee1c0"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kompose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbfdd7de743622c0464ce891b457d57a9c9c964a41f59ed7910c22a2f4748676"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6e3a9fed65ba2b2d20d710c6e43c7f67b6a9fd83d56a2af8f7161d6e4564ef0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6e3a9fed65ba2b2d20d710c6e43c7f67b6a9fd83d56a2af8f7161d6e4564ef0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6e3a9fed65ba2b2d20d710c6e43c7f67b6a9fd83d56a2af8f7161d6e4564ef0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8840c5b89aa212e21c8bbaf04b16252435fc858e02ee957839e0ff5711b7f54"
    sha256 cellar: :any_skip_relocation, ventura:       "d8840c5b89aa212e21c8bbaf04b16252435fc858e02ee957839e0ff5711b7f54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d23f312180dbe1e83aa5edcd79545196155e742fb0f00e15badd35d471789b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "738bc200f22ff1eb16445dc20b26e42e12a019fa8145e1e8ee35ac970e5618c5"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"kompose", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
