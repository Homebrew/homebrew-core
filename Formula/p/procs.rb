class Procs < Formula
  desc "Modern replacement for ps written in Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/refs/tags/v0.14.12.tar.gz"
  sha256 "f2fab583fe98a9ae9505c5eecf4f3d9d4ad9bcb5d478a8222d52c87aa1ac602e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23592dd3bdaa57279f198e356c8f02c8457ba81342413337aab402c48c1374e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46cfcda6903e01432bbe6d15ad82f315564f786c1831653d66705a0d122ad1fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97aadd82193fc5f196e65eb03e57555b859a672c4ac405a39b3a882043789452"
    sha256 cellar: :any_skip_relocation, sonoma:        "14a94612ac4a63282ff7e0066ae091a222207f6750244c5dff2afbbfc18c9ea5"
    sha256 cellar: :any,                 arm64_linux:   "8b66b076d2012cae0720c060b2d2b6e116665c9f70aaeb260977781c43e5466e"
    sha256 cellar: :any,                 x86_64_linux:  "25cc294174fe13bdf72332f74e71bc844a4369d16f9066207bc1b1f8122dfd31"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    system bin/"procs", "--gen-completion", "bash"
    system bin/"procs", "--gen-completion", "fish"
    system bin/"procs", "--gen-completion", "zsh"
    bash_completion.install "procs.bash" => "procs"
    fish_completion.install "procs.fish"
    zsh_completion.install "_procs"
  end

  test do
    output = shell_output(bin/"procs")
    count = output.lines.count
    assert_operator 2, :<, count
    assert_match(/^ PID:/, output)
  end
end
