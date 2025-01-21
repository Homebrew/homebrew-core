class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "584c14cadafe2658d09ed8bdb02d3b92e9b2d27efb7696dd4c830cd38446701e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c5d17d657baf760bc4b74de016e94e309d97f4dba3133d9f1ad0933a9ba9553"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c5d17d657baf760bc4b74de016e94e309d97f4dba3133d9f1ad0933a9ba9553"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c5d17d657baf760bc4b74de016e94e309d97f4dba3133d9f1ad0933a9ba9553"
    sha256 cellar: :any_skip_relocation, sonoma:        "6312834cd6653a14c80cf22e63010c2933f2cb8df9e9de3d474460eef971fcb9"
    sha256 cellar: :any_skip_relocation, ventura:       "6312834cd6653a14c80cf22e63010c2933f2cb8df9e9de3d474460eef971fcb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e097cab9d7a6075cbf7eca273bb1cc56fe5ebf83797e8a491852637a2db45d4"
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
