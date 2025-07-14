class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://github.com/wakatara/harsh/archive/refs/tags/v0.10.22.tar.gz"
  sha256 "941198dae44835635836459e8a682a13aa4ca5aed334f5adcd8b708746f5c366"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2f582ac18703ce292d79434f447cbc34a9737e9126dd75ffc309215ecee043d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2f582ac18703ce292d79434f447cbc34a9737e9126dd75ffc309215ecee043d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2f582ac18703ce292d79434f447cbc34a9737e9126dd75ffc309215ecee043d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c415d3f039f7aef867af13ffe3cfe9a7e881ec567ba12329baf8a438465373b"
    sha256 cellar: :any_skip_relocation, ventura:       "2c415d3f039f7aef867af13ffe3cfe9a7e881ec567ba12329baf8a438465373b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "768d4bad34551928261f87b117c1a5ff7e10b19647b9dad0fe0621097327f5ce"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Harsh version #{version}", shell_output("#{bin}/harsh --version")
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
  end
end
