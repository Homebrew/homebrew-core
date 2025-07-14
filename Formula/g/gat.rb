class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "df5766003034aeaff39ad8d2b3a3faf326961a06edd5387b8f06c72b2aca39f4"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b974198fd67de388ecb6028f8827b13fbdfaadbb51069acb83b5ea5c97d4fd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b974198fd67de388ecb6028f8827b13fbdfaadbb51069acb83b5ea5c97d4fd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b974198fd67de388ecb6028f8827b13fbdfaadbb51069acb83b5ea5c97d4fd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "42c7396dfb596fc577b577251f57b9ff529ef7906badf4ec98c952a7f4ef01d4"
    sha256 cellar: :any_skip_relocation, ventura:       "42c7396dfb596fc577b577251f57b9ff529ef7906badf4ec98c952a7f4ef01d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15bba8c0b42d76ce3650c144ac75d37c1eb15a56f16a8f9ff99f60b2cd643b70"
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
