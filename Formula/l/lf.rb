class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/refs/tags/r39.tar.gz"
  sha256 "1393f86a2387534dd5321754846e0fe39df55a7345ef2b19f349eb6ae96aaaf7"
  license "MIT"
  head "https://github.com/gokcehan/lf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26b70c4fcbd458b20288eda4a5fb712d75815e37898e764fbfad87759fc381fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26b70c4fcbd458b20288eda4a5fb712d75815e37898e764fbfad87759fc381fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26b70c4fcbd458b20288eda4a5fb712d75815e37898e764fbfad87759fc381fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "958324781000f3b0421533e65ec8e12fb3ea02c9c274379cce7a0dfb7cc6d87f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae7d98e56a200c0cb91d2e4d06fc0f3eae04b03335a45321928e56029991b6dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89a85624e5e97bff76eb87938c3e3a8590874f73f95a64eb97851b03196c2431"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.gVersion=#{version}")

    man1.install "lf.1"
    bash_completion.install "etc/lf.bash" => "lf"
    fish_completion.install "etc/lf.fish"
    zsh_completion.install "etc/lf.zsh" => "_lf"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
