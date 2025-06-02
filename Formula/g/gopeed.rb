class Gopeed < Formula
  desc "Modern download manager that supports all platform"
  homepage "https://gopeed.com"
  url "https://github.com/GopeedLab/gopeed/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "f7e0655bca4e414d1da26120b95ef2239556e9f23494fd76d23671264185cd03"
  license "GPL-3.0-or-later"
  head "https://github.com/GopeedLab/gopeed.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d7814d33cb904f6c66f1ae69da92e1313b3e96d219d826331cf216ea19aba66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f85ee328d204d1c55a2e5e77936070411ab0bfc2b5e2db56f73f8d9347f8710"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b2bbd886162fb0bfa92c820ce2e9655d6dd27f32528fd44f2707e920a1667c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "09b0663cff83aa10bb35ce61b51ed1942e715e8458a3130df0b02e341da7b863"
    sha256 cellar: :any_skip_relocation, ventura:       "07e9096aa3331e0f493d04dacad834fbcca174f3bfe55c74325415977a96c2c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3df97559f7bc80ec58370ea57eb310d67ab022b87423f30e5725597ea0b19dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04210ac095702086a532bfaa1a3d2c2f21ae52c66d28903f9ae97f0e21c53371"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gopeed"
  end

  test do
    output = shell_output("#{bin}/gopeed https://example.com/")
    assert_match "saving path: #{testpath}", output
    assert_match "Example Domain", (testpath/"example.com").read
  end
end
