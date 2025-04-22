class Erlfmt < Formula
  desc "Automated code formatter for Erlang"
  homepage "https://github.com/WhatsApp/erlfmt"
  url "https://github.com/WhatsApp/erlfmt/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "198f33ff305806d4cee5113884364d8874912f3ad0ec3d0aa2ca243cfadc44b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fbbef6f018c0c72fc01f47a19fb0dcbf67139a6e2dc20b823a31a0c360b797f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72f652c4227d1ca282720fdc28897acbb2e3ee4d7819478b9d47396c968b72aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1ee4356795cfda85a71a60d1c881ddd929cd2d3407723394abd541da5c0641d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8b92b9571a99b94d4e70ac8eff531ae1237ed6ee5180ee95f79b50f606164f2"
    sha256 cellar: :any_skip_relocation, ventura:       "c0b75fa981fd2a99924ca62063759138d14c1e30016977a5a8d9900fa77eb8d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e04c2c3c2379399b583171d345a3e48abb88a0ac2b8eaa5c35037dea6da11fd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e128140ccd3ebf3093cb97d9e0dbdf7024ba8d8477f6a1b6996c074963fe7034"
  end

  depends_on "rebar3" => :build
  depends_on "erlang"

  def install
    system "rebar3", "as", "release", "escriptize"
    bin.install "_build/release/bin/erlfmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/erlfmt --version")
    assert_equal "f(X) -> X * 10.\n",
                 pipe_output("#{bin}/erlfmt -", "f (X)->X*10 .")
  end
end
