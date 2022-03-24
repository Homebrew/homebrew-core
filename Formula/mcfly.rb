class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https://github.com/cantino/mcfly"
  url "https://github.com/cantino/mcfly/archive/v0.6.0.tar.gz"
  sha256 "dd846f7ff7109921febc8aecdfd769a1258488a0d72b4a0cfcfa3eaac118b1bc"
  license "MIT"
  head "https://github.com/cantino/mcfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bbce1c09b6e732a58c625b1ce5bf115efd3eb34c3ea631db9b31f6043c99b38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b37e1f6920c9c591d7a339855f86e7a19a5f549f23ec88907e0811e084332717"
    sha256 cellar: :any_skip_relocation, monterey:       "c5afdcc6c7606d5acadac9a85c6eaabe8f73086fc5031e630209f2eeaa983ef0"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cfcc9eceec4c4449f63d22636823234a0f940d0e54e166797d8a8199d8daece"
    sha256 cellar: :any_skip_relocation, catalina:       "07facab360d6bca0b0bc8144012ca0d27f2240bb05d63e385cab393057cb73fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "603831898a3aa6049a38d3d35afb3bd4be08470bdb7b66eebdd2926e275a8602"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "mcfly_prompt_command", shell_output("#{bin}/mcfly init bash")
    assert_match version.to_s, shell_output("#{bin}/mcfly --version")
  end
end
