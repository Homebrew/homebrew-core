class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "5d64f160693b4a29c7ace1ab6234e25f9bae64188556ad6876c5ee150cc7633c"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c99a1db0aed941c7a5803d082587554746b1acefe98b92ff3703a22889878fef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c99a1db0aed941c7a5803d082587554746b1acefe98b92ff3703a22889878fef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c99a1db0aed941c7a5803d082587554746b1acefe98b92ff3703a22889878fef"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0e7bcefb77036cb81373d55ddcd3ed73d73d1ba7b4cee36e87c150b68ec6a86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f05a48f0ed0a6456907ff4bb072187feba1c938518d34959218e2edbcd090971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e24cad24cb3874a15912ba83edd376d6c1011e1bff12531c83d455790ebcb332"
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
