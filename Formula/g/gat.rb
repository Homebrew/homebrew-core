class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "a3f9d4452ff42e2f39ad972bad8debef8d71f0cf697bf6939ae1e66cfd56db61"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "110cc16eac8d0d3dd7d01d0cfbf29617481ecd6e8d35a8c5e48dac75e5a89a90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "110cc16eac8d0d3dd7d01d0cfbf29617481ecd6e8d35a8c5e48dac75e5a89a90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "110cc16eac8d0d3dd7d01d0cfbf29617481ecd6e8d35a8c5e48dac75e5a89a90"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9bdd38f26c59e7a489453fb1f218343f44d86c9094975d172ee15c4e5277d64"
    sha256 cellar: :any_skip_relocation, ventura:       "a9bdd38f26c59e7a489453fb1f218343f44d86c9094975d172ee15c4e5277d64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8a8fd46aab555312e2c348f47f4b0732659ace2820e0f3abfbe50d249667d48"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end
