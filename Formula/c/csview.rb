class Csview < Formula
  desc "High performance csv viewer for cli"
  homepage "https://github.com/wfxr/csview"
  url "https://github.com/wfxr/csview/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "7c5ae0ff515b97267a0d47b15783d77f6b14d057e7e6110127f19d1f7b61e291"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/wfxr/csview.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0884bbee44963ceff87d08249b66b6767dcbf8768fa780a685e957f165acc9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cf7361497a5324b29add80f2170ab03e7378ba3f9b3874629a73990f22c69ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82fee6b933e93ddfd7f50f714b91f3ad927cf95ce3ada2437454e1b7a7e29948"
    sha256 cellar: :any_skip_relocation, sonoma:         "a74fb4d9ca487cb2e5953208ec56a92c97182fb89b8363581235cda5de9974fd"
    sha256 cellar: :any_skip_relocation, ventura:        "8b889a3b4e18bdc86dba65c41fa4819949542fda17b85fc9de6ee67018a8b164"
    sha256 cellar: :any_skip_relocation, monterey:       "2f0c2c60963568a4144976ba5e3cda1dd9f273bdb0d9795587021b2eed3a06e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12243fad9b57ac5d7da9bbe6778be6ea6087b8a39f920fc74e995369ae83d920"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    zsh_completion.install  "completions/zsh/_csview"
    bash_completion.install "completions/bash/csview.bash"
    fish_completion.install "completions/fish/csview.fish"
  end

  test do
    (testpath/"test.csv").write("a,b,c\n1,2,3")
    assert_equal <<~EOS, shell_output("#{bin}/csview #{testpath}/test.csv")
      ┌───┬───┬───┐
      │ a │ b │ c │
      ├───┼───┼───┤
      │ 1 │ 2 │ 3 │
      └───┴───┴───┘
    EOS
  end
end
