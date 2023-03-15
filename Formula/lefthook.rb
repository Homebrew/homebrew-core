class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "e9054b140d452bd95fa94aa734de8808e9e9792f79e6942b6561d76d972673c4"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c2c7821a262481adcaf7b600ae2b5174a60fea5b92bbeaa15fb1d1e78942a15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c2c7821a262481adcaf7b600ae2b5174a60fea5b92bbeaa15fb1d1e78942a15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c2c7821a262481adcaf7b600ae2b5174a60fea5b92bbeaa15fb1d1e78942a15"
    sha256 cellar: :any_skip_relocation, ventura:        "18a8b92f9695375bc5500cfdf3a5c6a308fb88bb920bc67e6b92e4fbf96d79c7"
    sha256 cellar: :any_skip_relocation, monterey:       "18a8b92f9695375bc5500cfdf3a5c6a308fb88bb920bc67e6b92e4fbf96d79c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "18a8b92f9695375bc5500cfdf3a5c6a308fb88bb920bc67e6b92e4fbf96d79c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f0d7b6c7cf33aa6315599a94a981ebcb60d9b1bee2ccd6d5c81e4fafe1821a7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
