class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v8.6.6.tar.gz"
  sha256 "ca77320f81bf535924d68f910ba48cda26d635cda80d86ad99f26e6aeddd93d9"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dec9cc57a2b118138176af7c107ee69472036c30d746cf2135ad81b424d1a560"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dec9cc57a2b118138176af7c107ee69472036c30d746cf2135ad81b424d1a560"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dec9cc57a2b118138176af7c107ee69472036c30d746cf2135ad81b424d1a560"
    sha256 cellar: :any_skip_relocation, sonoma:        "b568f83120650dd37329432e19497ff6de33c1cccdcf81be3ff012132968a4d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a17ae8ec4106ce5734ba646b70007c825f95905abff47cff811db03403d5dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04f7bcbfcbebf53a212de2948fc2e5bd6b2edd751c5864ae01f6e2460ded2c48"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
