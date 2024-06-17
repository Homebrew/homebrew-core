class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "28d1d50a29ede093809b08ee6ac2f8a1a9c748728f481835fad3d2b45b0cec83"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c373d2bf9efa63fd7c2fde0ebcfeae6117d766a09f5ca1b6e3b55bb7a4fe4a54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c373d2bf9efa63fd7c2fde0ebcfeae6117d766a09f5ca1b6e3b55bb7a4fe4a54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c373d2bf9efa63fd7c2fde0ebcfeae6117d766a09f5ca1b6e3b55bb7a4fe4a54"
    sha256 cellar: :any_skip_relocation, sonoma:         "c723747409130b7285aa72d74f37b7045d1294747e81cea73dcb2f90648349a3"
    sha256 cellar: :any_skip_relocation, ventura:        "c723747409130b7285aa72d74f37b7045d1294747e81cea73dcb2f90648349a3"
    sha256 cellar: :any_skip_relocation, monterey:       "c723747409130b7285aa72d74f37b7045d1294747e81cea73dcb2f90648349a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84ed11a9539dd7b6ba9c017a75cac5aa9eaf3f431a5a6462a931ec7f1d450174"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    man_page = Utils.safe_popen_read(bin/"gum", "man")
    (man1/"gum.1").write man_page

    generate_completions_from_executable(bin/"gum", "completion")
  end

  test do
    assert_match "Gum", shell_output("#{bin}/gum format 'Gum'").chomp
    assert_equal "foo", shell_output("#{bin}/gum style foo").chomp
    assert_equal "foo\nbar", shell_output("#{bin}/gum join --vertical foo bar").chomp
    assert_equal "foobar", shell_output("#{bin}/gum join foo bar").chomp
  end
end
