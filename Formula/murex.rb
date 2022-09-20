class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v2.11.2030.tar.gz"
  sha256 "5d7dadc2d48bde20fe2239d8087612eccaa310b0f88863bdae2288b30388dff7"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bbc2412b20ddbee0fc6445c4b5151442cbf8a0a9d7a7096b868d856c9d439a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8b6facac6d3cfa1835d0a58cfd3fe28b8f46b66cb81e19f0f24e60e238b0343"
    sha256 cellar: :any_skip_relocation, monterey:       "337a0549a2fe28a03af1227afe34d3b80bd30485dc4f19846aaf353b55b280a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "bacea5f924adbdaf137d467f667be403f903045a79ef0465c57fc63a7f704e05"
    sha256 cellar: :any_skip_relocation, catalina:       "582e8d18010b16bcec8690b335c262d542da17b0846db8eb2589b193519c88ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df3ef1b96c611578577d93ae2c5d47ff526d2344158eebe2c9336ecb709819bb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end
