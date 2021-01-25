class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.0.5.tar.gz"
  sha256 "a11aad345212e12d461fbe5410e25be0e1c934f6c7afec50307f6520adb33240"
  license "MIT"
  head "https://github.com/prest/prest.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c101c96f4fd8d3b06e0cfc54a69bdc0642edfe332798c405a03d3e2e31f1b070" => :big_sur
    sha256 "9ced6ca37e5bb761ce0a9c9193cb708256c562cdd40a61175c0baa15fa8eaaf9" => :arm64_big_sur
    sha256 "928c4bedf740e8175a043f897127f91e6d2dd05ce2db6082a17d08e860cebe22" => :catalina
    sha256 "71dbc89a3c45c6a900f66683150e10b9d8e989d34abfa49d5f9ced013b227e36" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags",
      "-s -w -X github.com/prest/prest/helpers.PrestVersionNumber=#{version}",
      "./cmd/prestd"
  end

  test do
    output = shell_output("prestd migrate up --path .", 255)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("prestd version")
  end
end
