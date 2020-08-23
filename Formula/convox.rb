class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.39.tar.gz"
  sha256 "d0463a18136a444b205637a2e469fd8c7ad651e11d2f3a17f3002616e960f52a"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "b62171ef51c1017aa870388dc232f43b6f9f84657e83d8128710f470ffbc6a73" => :catalina
    sha256 "c31194017443911acb240f42dc823f1cf0c79d856fb4499d475cd7f65a27e63b" => :mojave
    sha256 "f3d44595da202f318d089724cf8f187425cf2439055478b30c5aec2ea5f5b10c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-mod=vendor", "-ldflags", ldflags, "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
