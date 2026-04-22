class Csprecon < Formula
  desc "Discover new target domains using Content Security Policy"
  homepage "https://github.com/edoardottt/csprecon"
  url "https://github.com/edoardottt/csprecon/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "86fb95ccf78a032c4ec47b5c70d859936824e69a05b18170a5b5db67c88a93da"
  license "MIT"
  head "https://github.com/edoardottt/csprecon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cf5b0f0c6f93c46ba5faf23b29677d27a9cf7727e639377821e8aec271a5eab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cf5b0f0c6f93c46ba5faf23b29677d27a9cf7727e639377821e8aec271a5eab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cf5b0f0c6f93c46ba5faf23b29677d27a9cf7727e639377821e8aec271a5eab"
    sha256 cellar: :any_skip_relocation, sonoma:        "21554ef36d3abe33dd097e32f64809945f5df86c15341159ad00565ca16ed4c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a08e84e385a9c23b63357950732e05d2f364e8cf3f4fe236470efba0dc0fb684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "795f035cbf4f75e1a8f9200171587198b5644889f925ae14e41c814738da7670"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/csprecon"
  end

  test do
    output = shell_output("#{bin}/csprecon -u https://brew.sh")
    assert_match "avatars.githubusercontent.com", output
  end
end
