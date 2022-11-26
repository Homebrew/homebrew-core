class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v8.5.3.tar.gz"
  sha256 "45a6444cf5bbfcf4ee4836d9a2ff2106d31e67da77341183392225badc87cd35"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f4a818e289969385257b5418e264bce60b0c5346638d0c933acd93c13d4c8df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adabea848971a0d8f572124a90e9c67b95e7553d785c616b1445094b1522b114"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93909239940e2b5bb9c4d9742c4dc25cb82653a3737baf1d35d2d9cfc5545cb7"
    sha256 cellar: :any_skip_relocation, ventura:        "6e4d99a6f5c3500c38b490555e62762eaa381572f9d7237b8c151ddad27e37e1"
    sha256 cellar: :any_skip_relocation, monterey:       "7b334e80bd27fcbb7f7431f6bdea253c90704733c96010c0498477cc340b3807"
    sha256 cellar: :any_skip_relocation, big_sur:        "45143a7f02340ae2f323cc89b74e7002f964dc84701a7bb1ef0129e409afb894"
    sha256 cellar: :any_skip_relocation, catalina:       "ff657fbed920ac915a97df106ace9efb87af33ffc3b545200fa1dd6d70a8de07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7173e54cccdc708ab1c37a2d2af699c1ba7035510fef4fe2f0eb957c3f17ad42"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/fd.1"
    generate_completions_from_executable(bin/"fd", "--gen-completions", shells: [:bash, :fish])
    zsh_completion.install "contrib/completion/_fd"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
