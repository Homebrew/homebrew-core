class Gomi < Formula
  desc "Functions like rm but with the ability to restore files"
  homepage "https://gomi.dev"
  url "https://github.com/babarot/gomi/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "352f7792c7917ecbb8ab6e46d6360c7fb03a8c7f8bb7dc53ff9f5bd4633fb269"
  license "MIT"
  head "https://github.com/babarot/gomi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4fb51bf665b25c712e141d44968ddc08ba1d904417e2016380947edb862278c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4fb51bf665b25c712e141d44968ddc08ba1d904417e2016380947edb862278c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4fb51bf665b25c712e141d44968ddc08ba1d904417e2016380947edb862278c"
    sha256 cellar: :any_skip_relocation, sonoma:        "01bbbe1fe183879d320af153111f618e641410696c5d0326481a7030e9b9872b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba786a127bd8d20f410324b5885022eaedc91a7fed50a7c169103a29bc3e2b76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83fdaec4ab71501a2845a309bd43bfd9c3a84bff7e7f738a98b62158e4c5c390"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.revision=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # Create a trash directory
    mkdir ".gomi"

    assert_match version.to_s, shell_output("#{bin}/gomi --version")

    (testpath/"trash").write <<~TEXT
      Homebrew
    TEXT

    # Restoring is done in an interactive prompt, so we only test deletion.
    assert_path_exists testpath/"trash"
    system bin/"gomi", "trash"
    refute_path_exists testpath/"trash"
  end
end
