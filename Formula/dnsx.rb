class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/v1.1.1.tar.gz"
  sha256 "b136298b2139bf5a2c94d4b2b41419ef63681c900fc9d6cec586eec7e1ed479c"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0334150e78dabc33980f35ddb8979afd7c966aebc8b8c28286601f5862349db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5731182b9f7114e796a972d740ba915094ea94cb27b91b20de79c6818186bd1a"
    sha256 cellar: :any_skip_relocation, monterey:       "af4032a8ad5d689dad9afb4740b176a9804a2993e254620ed310a9ca633e9af4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7237c04b9c4e0fbc744e02b94faadebacb6c3bb3d22460ec77e9f2672af999d"
    sha256 cellar: :any_skip_relocation, catalina:       "a6ac95d8caacf7c6ae9a5b89dbd8b5b26833d1d4a0cba7ed4b0743faa09f1481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abec4ef11a53ce8f0fbaff5c3e63e466639271b324f698a17d536ed89626532e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dnsx"
  end

  test do
    (testpath/"domains.txt").write "docs.brew.sh"
    expected_output = "docs.brew.sh [homebrew.github.io]"
    assert_equal expected_output,
      shell_output("#{bin}/dnsx -silent -l #{testpath}/domains.txt -cname -resp").strip
  end
end
