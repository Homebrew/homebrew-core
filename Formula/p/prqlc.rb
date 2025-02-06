class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/PRQL/prql/archive/refs/tags/0.13.3.tar.gz"
  sha256 "f64c22933ba0d4f5664bacbd2278de41baf74cef3a20e86b718dbd6348fc369f"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9285a7b88adc1b1f13b178024f3257298d187996ece4854e012859cdf7c35a8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4eb5b818c6636a2a6643db9f4998199fda78a0b3c337ea9b533acab6d388334e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f24dd39877c07926ac0fe9d08aa4d243d4440cac2ec0ddd61c1cde7ab89842db"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1fdd340538cbc8bc12b8742c0c1ab3d12ceae1c6c397503d42b31b2a00ac520"
    sha256 cellar: :any_skip_relocation, ventura:       "fabdcd16ff792aac004bd45025385cead0fc73cb3210299b850b734b05e76335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "160d2f6e949c8e8de1e0e2f897b4fe5cd33515b1fbb7346bd1a55f312164ac7d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prqlc/prqlc")

    generate_completions_from_executable(bin/"prqlc", "shell-completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prqlc --version")

    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end
