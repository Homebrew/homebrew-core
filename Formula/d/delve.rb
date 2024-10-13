class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "52554d682e7df2154affaa6c1a4e74ead1fe53959ac630f1118317031160a47d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8be280feb48740a107882012fd60fe43b5a93b089faf19c4254f3a866a43a60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8be280feb48740a107882012fd60fe43b5a93b089faf19c4254f3a866a43a60"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8be280feb48740a107882012fd60fe43b5a93b089faf19c4254f3a866a43a60"
    sha256 cellar: :any_skip_relocation, sonoma:        "b442c715d04ec984b0090f22c8256e3a613455ab4e65b7dbc1dde3a0f812f0c7"
    sha256 cellar: :any_skip_relocation, ventura:       "b442c715d04ec984b0090f22c8256e3a613455ab4e65b7dbc1dde3a0f812f0c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd557411e2b906cbc4a6bf61102dd249fb20835f53e3c436ca9e727b66fd48c5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
