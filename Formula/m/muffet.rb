class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "c54af3f50150d7a58d83d1d33b98a489f6bc0d0290887b3ae18e6677e08e1737"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "221d1b0a3b2e23b334f201249f6baa37e217c4186ae35ccd5b59f6fb9a6501f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f58e2b267538228d28ea3069c1c5b432fdd2e9c475c65ba9183a3adc083e7b3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f58e2b267538228d28ea3069c1c5b432fdd2e9c475c65ba9183a3adc083e7b3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f58e2b267538228d28ea3069c1c5b432fdd2e9c475c65ba9183a3adc083e7b3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "149591faaca9fa1d39b175089c689fab3406dd32d85b5fe87e10eb358717bcdd"
    sha256 cellar: :any_skip_relocation, ventura:       "149591faaca9fa1d39b175089c689fab3406dd32d85b5fe87e10eb358717bcdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a641c254962700602d855f28fd858d73eb692c5047326baaf81c4b625f903fed"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://example.com/",
                 shell_output("#{bin}/muffet https://example.com 2>&1", 1)
  end
end
