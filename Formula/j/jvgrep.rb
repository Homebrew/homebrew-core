class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/refs/tags/v5.8.12.tar.gz"
  sha256 "7e24a6954db1874f226054d1ca2e720945a1c92f9b6aac219e20ed4c3ab6e79c"
  license "MIT"
  head "https://github.com/mattn/jvgrep.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "963ff6621f2dc1267f68d17325513c073972ccbf6d49593426755d3431af5179"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75446e73d07e20f8f669a8aad8d06afa0ce4af12646e77c76cc985df3190a6a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75446e73d07e20f8f669a8aad8d06afa0ce4af12646e77c76cc985df3190a6a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75446e73d07e20f8f669a8aad8d06afa0ce4af12646e77c76cc985df3190a6a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "67d7ddecea5ea8a4f38e466a044f33156864e65df221a990b11d20366be2e462"
    sha256 cellar: :any_skip_relocation, ventura:        "67d7ddecea5ea8a4f38e466a044f33156864e65df221a990b11d20366be2e462"
    sha256 cellar: :any_skip_relocation, monterey:       "67d7ddecea5ea8a4f38e466a044f33156864e65df221a990b11d20366be2e462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c903876a35a55737263a79668f2f4f915c38481e0299ebe9f4296a66c4899c0b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"jvgrep", "Hello World!", testpath
  end
end
