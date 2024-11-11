class Energy < Formula
  desc "Energy cli auto dev tool"
  homepage "https://energye.github.io"
  url "https://github.com/energye/energy/archive/refs/tags/v2.4.5.tar.gz"
  sha256 "266e436fab3ecd322c0753a7592b6be862ce1e44d31c4282edac5ddccb8057be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e048169778f8a017306c4f876cd4e36fb3e7bfe809a2e1fa5036545397d319a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c80c3a761809ed97b83029dc4e4f39cc90cc99dad895db238599a378ffb139a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c80c3a761809ed97b83029dc4e4f39cc90cc99dad895db238599a378ffb139a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c80c3a761809ed97b83029dc4e4f39cc90cc99dad895db238599a378ffb139a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "24570e41843f45493539397ef7a9cb9533d581418b1dc44908690fb032c716f4"
    sha256 cellar: :any_skip_relocation, ventura:        "24570e41843f45493539397ef7a9cb9533d581418b1dc44908690fb032c716f4"
    sha256 cellar: :any_skip_relocation, monterey:       "24570e41843f45493539397ef7a9cb9533d581418b1dc44908690fb032c716f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3c89999c25f245dcd4e4e2b946ac4902c7cfe4b3c60a31edf19fe6f30453911"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/energy"
  end

  test do
    output = shell_output("#{bin}/energy cli -v 2>&1")
	assert_match "CLI Current", output
  end
end
