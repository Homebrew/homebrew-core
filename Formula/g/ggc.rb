class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v8.2.1.tar.gz"
  sha256 "36d3ceb5853a5985e3248e870d3c4ab4a5351777b3f03c2eeb5d994bf5dec62e"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66b2db44522f0e73b14c2b71c098b791340f06a42e9ccf192626a8379fede95b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66b2db44522f0e73b14c2b71c098b791340f06a42e9ccf192626a8379fede95b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66b2db44522f0e73b14c2b71c098b791340f06a42e9ccf192626a8379fede95b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c1fdb08d1c593f86b0298d429473379c03be56bd3817cc58635b350c721bb2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81f5ac17b1c33efde67632b39335dcd463b5484f78d74535265ff3f37a011a63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1894a51adfbc1fc046d14b22b41fd5429f258d1f4336843502e46b0d322b1a18"
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
