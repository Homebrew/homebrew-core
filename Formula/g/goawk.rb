class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "9d76415c6ce54c676428aa946ae1c4bc93863a3c680c8137711e65192628d7a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83d5cb4723b3719e3911106bb9fc85055632c883650ac34fc591bb3a610d8042"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83d5cb4723b3719e3911106bb9fc85055632c883650ac34fc591bb3a610d8042"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83d5cb4723b3719e3911106bb9fc85055632c883650ac34fc591bb3a610d8042"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d18b5c845187f84865f272cfbfa863886b8802a4e733240f982e76a2645635a"
    sha256 cellar: :any_skip_relocation, ventura:        "8d18b5c845187f84865f272cfbfa863886b8802a4e733240f982e76a2645635a"
    sha256 cellar: :any_skip_relocation, monterey:       "8d18b5c845187f84865f272cfbfa863886b8802a4e733240f982e76a2645635a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05571aa5374108815e4c366acd675012b14196e9afe548ae7bc81a6e36c31f57"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
