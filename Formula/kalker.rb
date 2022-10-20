class Kalker < Formula
  desc "Full-featured calculator with math syntax"
  homepage "https://kalker.strct.net"
  url "https://github.com/PaddiM8/kalker/archive/v2.0.0.tar.gz"
  sha256 "092ab13726515125ec3664c15e61fa7b8eec09ad590f0c5ef00df6e33b3b3da7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "281638cc7dc299a1d172a71a1987c83b8a607c768a5079c9eabf7c18b8651068"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d356a52f4501a02f564c7960d9b35155dab33eabf2b6923c5bca9eb4aba0df6c"
    sha256 cellar: :any_skip_relocation, monterey:       "f0859b24ffdd063be5371f29105437ba0152669e64ec7f5bfb37aaa856b17418"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fc0fddcc274b68cc81b08eda7ef348939bf9804fec4d8c1726221c933f5949f"
    sha256 cellar: :any_skip_relocation, catalina:       "4be457caaed473e8150d5c77791008e6850f138ff3e846cfe495f5d19249d960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7eba326a767e9355f75ab55b835d565eebbf59e748a4d5a2663163e0e910a2f"
  end

  depends_on "rust" => :build

  uses_from_macos "m4" => :build

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_equal shell_output("#{bin}/kalker 'sum(n=1, 3, 2n+1)'").chomp, "15"
  end
end
