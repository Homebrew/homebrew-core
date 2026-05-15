class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v8.4.1.tar.gz"
  sha256 "d25f219aa1778511e897a1649d38fa50b0d12f690ccd5056792735477ac614bd"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0060e537a00be1409bd1c9b0af0c20f04a60172f6e0251679def87052526fa0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0060e537a00be1409bd1c9b0af0c20f04a60172f6e0251679def87052526fa0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0060e537a00be1409bd1c9b0af0c20f04a60172f6e0251679def87052526fa0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1c4533b525e011b719edfa467c14293cba18acd68b93cb28f6dd1c872265a9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6c4206c816c6e4504337f644e16e6fc842962ba1932be67bccf70863650a623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88f7f37ddc43ca058dbd20a427d86e9b1922ee0f187421a562f31b9ecbff02e6"
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
