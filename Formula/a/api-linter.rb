class ApiLinter < Formula
  desc "Linter for APIs defined in protocol buffers"
  homepage "https://linter.aip.dev/"
  url "https://github.com/googleapis/api-linter/archive/refs/tags/v1.69.2.tar.gz"
  sha256 "a6c10a8d0b9a9186db3419075adae497f5fa169113a22a742c05444e711dbaf0"
  license "Apache-2.0"
  head "https://github.com/googleapis/api-linter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "562e32b91b590f63e4b84a890fa0c85f186c538393b4831fa83687fdaf37740e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "562e32b91b590f63e4b84a890fa0c85f186c538393b4831fa83687fdaf37740e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "562e32b91b590f63e4b84a890fa0c85f186c538393b4831fa83687fdaf37740e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1853e3420fed61d571b911d032fc4987d718da146bada34285c75a9f43af3dba"
    sha256 cellar: :any_skip_relocation, ventura:       "1853e3420fed61d571b911d032fc4987d718da146bada34285c75a9f43af3dba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05821db020cab71b0d94325d43bb8e912e900a575443237ca1ecacb6f854ec3c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/api-linter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/api-linter --version")

    protofile = testpath/"proto3.proto"
    protofile.write <<~EOS
      syntax = "proto3";
      package proto3;

      message Request {
        string name = 1;
        repeated int64 key = 2;
      }
    EOS

    assert_match "message: Missing comment over \"Request\"", shell_output("#{bin}/api-linter proto3.proto 2>&1")
  end
end
