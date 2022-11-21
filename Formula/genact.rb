class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/v1.2.2.tar.gz"
  sha256 "72ead4b84e4ca733ae8a25614d44df3f3db5e47e54913ed9fbfecd2f5212a632"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19f959ebaa46a9693d5c477af4978b8483497444529a599bc3ade1015c45f38c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86f8f5a41ff5310a19af6be233783006e16630d479ce4cc1d33a25b4673c2de0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9a2cdeb2a5ba1bdbc1b9ab61255952fa9c692d747b35de07e5b5dc228d45594"
    sha256 cellar: :any_skip_relocation, ventura:        "c2413327f10fc11695cccfc724526ba009a1e5712ba82c9eaea9e2ae80b1ebf5"
    sha256 cellar: :any_skip_relocation, monterey:       "09b5d1c206164a5ee28d650f9cb01b5ff1698ae737680bf9fd817868916374a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e2604dc557d38f3ef515b270de3fb6ea4dcacb6c968d9e99953e97848cb3fb5"
    sha256 cellar: :any_skip_relocation, catalina:       "301d8e05b78b786cd7483aca4beedd0c776f712483683b4f5ca11d56dd18ac3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f9c80b1ab443eacb3b3160f23b6061fa9371f21669a40c8264cac7dac9f69cf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Available modules:", shell_output("#{bin}/genact --list-modules")
  end
end
