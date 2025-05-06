class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.26.4.tar.gz"
  sha256 "1793c7a14c5c9c1909274c44bc11a231532fb91c2a8eae8c5f47c1bfc2358b3f"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b89c34f41817876dc4aafdebe8afedd5a0cc6d41aef59959391588f9fab269df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b89c34f41817876dc4aafdebe8afedd5a0cc6d41aef59959391588f9fab269df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b89c34f41817876dc4aafdebe8afedd5a0cc6d41aef59959391588f9fab269df"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbe93b310a313c14605a9402a436d3c722c4f1e1b735a7fc66f8bd9d73e8365f"
    sha256 cellar: :any_skip_relocation, ventura:       "dbe93b310a313c14605a9402a436d3c722c4f1e1b735a7fc66f8bd9d73e8365f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f3ef93d62ff8ae49dde6b2de769afd63d7306bf166b9782dc6b8e163a5bd37b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d5a269d3093de1027a8b10b857dee23319836b52cdcad76ec2877fda4703ad8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
