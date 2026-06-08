class Csprecon < Formula
  desc "Discover new target domains using Content Security Policy"
  homepage "https://github.com/edoardottt/csprecon"
  url "https://github.com/edoardottt/csprecon/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "99deab536e5dc436d43f1971222b196e82fdaa1ba9b43684239ef8b723b01f6d"
  license "MIT"
  head "https://github.com/edoardottt/csprecon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5c5d071902795993ac9ac7c907c9aa1e5df57f98e41fde922ce7a4df5cf28e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5c5d071902795993ac9ac7c907c9aa1e5df57f98e41fde922ce7a4df5cf28e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5c5d071902795993ac9ac7c907c9aa1e5df57f98e41fde922ce7a4df5cf28e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "caa5d34e826837d065db28302463a92d9bd0ca678dcec9b8cd34f745cde84a67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e69bbbc30582405a0881769b8f280bb3f4ceef96f2f8810e5ed8c5150a9627d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acee474f9bc3d53e0229b40feacfdd11c988a95c53ffa0bfa1341a044767d14c"
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
