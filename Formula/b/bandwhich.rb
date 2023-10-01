class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "f9c50c340372593bf4c54fcf2608ef37c2c56a37367b2f430c27cce3ea947828"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4febc302b373bf2ba0d07550eb49628d3e0662d6f7985b443aefad0af4894213"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "120f28334b42d1f6e3c172f0ad38f4a48449748bf2cadfbf4ac014666309fb94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29e5dd8e4d10a9be06d05ceb3d283f9a497218f0810269c697eec30e2b24828d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46031f77a9dfea0b11325960aa8d217d7b186a18874fa75c2a8581a43312f854"
    sha256 cellar: :any_skip_relocation, sonoma:         "353fb676a554c87b28ad5f66fdc455990f6ec89932e88fd112249f238a8e5a7f"
    sha256 cellar: :any_skip_relocation, ventura:        "79fae453af66e4c2e1f1f53149a9f9b0dd00ed616b00a36dfbeb8c670116825c"
    sha256 cellar: :any_skip_relocation, monterey:       "6a5c5263bc9321b0657bbb22cbb8327d710710be819acf08c3ceaaeaa035633d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5d76f7cf5e9746513f9a259e0b1d5e0746f07a93b833a220722c4336ba8bd57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd8633f1537b5be7d607abff1482e18c1c8cec3fe8f90c24bc89630d7b369658"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/bandwhich --interface bandwhich", 2
    assert_match output, "Error: Cannot find interface bandwhich"
  end
end
