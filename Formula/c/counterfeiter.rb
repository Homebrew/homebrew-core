class Counterfeiter < Formula
  desc "Tool for generating self-contained, type-safe test doubles in go"
  homepage "https://github.com/maxbrunsfeld/counterfeiter"
  url "https://github.com/maxbrunsfeld/counterfeiter/archive/refs/tags/v6.7.0.tar.gz"
  sha256 "e5f7ec8cd40ee82a54b255c2f295fc6a2285fb161b330cb021890cf0df888bc2"
  license "MIT"
  head "https://github.com/maxbrunsfeld/counterfeiter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16fdcb71b5887ab145368cea470a03d5e428e701738a9534dd88959ea7300581"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e73be61cdc53c9f6ca7e1cca448e60a2ebfff526800c3811aa0643ccf8ea20b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c38b8e3644abedaa8bd16e157f52e79a7e39690e8f7d182230b7bef461c26f8"
    sha256 cellar: :any_skip_relocation, ventura:        "4d4920f7072e6a520b918bed28d5f7ac89240b8c5288fb0c3e41d1fc4956127d"
    sha256 cellar: :any_skip_relocation, monterey:       "98834b7f6fcedbeb47b4c2791d35f27215790219ff1db7bd8509e65f5e995419"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b8986c33e6464f6381f9ac8f175d6ff0b9e014f09c95e8b1db6e7ab983d5676"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebab4e8988af4aa6eeabe3f9b56ba1fab43cb9c007d8987c37ea6908207ab38d"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GOROOT"] = Formula["go"].opt_libexec

    output = shell_output("#{bin}/counterfeiter -p os 2>&1")
    assert_predicate testpath/"osshim", :exist?
    assert_match "Writing `Os` to `osshim/os.go`...", output

    output = shell_output("#{bin}/counterfeiter -generate 2>&1", 1)
    assert_match "no buildable Go source files", output
  end
end
