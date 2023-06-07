class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/v0.10.0.tar.gz"
  sha256 "6084bd89fdb51bbe58ef2a576e81f7d66471a48acc4d8aae41deff5cbb41a2ab"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c5fd15ee798b9658ba4dfaa8a1dbba8cc637cb4570e75d9fb7ab46320431573"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c5fd15ee798b9658ba4dfaa8a1dbba8cc637cb4570e75d9fb7ab46320431573"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c5fd15ee798b9658ba4dfaa8a1dbba8cc637cb4570e75d9fb7ab46320431573"
    sha256 cellar: :any_skip_relocation, ventura:        "7306fccbfca2c06ab761c4c607e431e7a679be13890ca1260f85e883c51c09bc"
    sha256 cellar: :any_skip_relocation, monterey:       "7306fccbfca2c06ab761c4c607e431e7a679be13890ca1260f85e883c51c09bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "7306fccbfca2c06ab761c4c607e431e7a679be13890ca1260f85e883c51c09bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05a89f3fca7bac680962a90fea4b164991b11f167a88d36c2be398d56ed2c167"
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
