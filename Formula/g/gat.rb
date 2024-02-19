class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "24f6775b08bb7bab9d1995fd9dce918d005586c6c42c0323d5bb2c87b3c24f93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a996cdf48f9aa356adc94b75d2c192434f1afc14d55b769ec1d8bf18ba204cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1390108f8f04b049f15f5abe444e1170fde76be564a0ce898d790b4abc91cb39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15257261e033e7582a6ac945b2544c5c5fc5409eb93b90be0b9c10b3a84daba6"
    sha256 cellar: :any_skip_relocation, sonoma:         "759433412b7aad7882fb7958388ba93896a0376b626b0d0cca2edb2b574411b0"
    sha256 cellar: :any_skip_relocation, ventura:        "719f22339bffd81d65d3639f15e1868b6b1eb3d67aa74ccec071cb4f20b969f4"
    sha256 cellar: :any_skip_relocation, monterey:       "92b8a3e9bc6226512be95843507361ea7ca874ff7cb4535b975c3cadab786121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c1ee7fc89e056dd29a4ce6254497958c642b15e4f7f2c4f59a92b79633d8c9f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end
