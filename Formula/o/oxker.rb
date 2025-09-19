class Oxker < Formula
  desc "Terminal User Interface (TUI) to view & control docker containers"
  homepage "https://github.com/mrjackwills/oxker"
  url "https://github.com/mrjackwills/oxker/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "d86a67ea88855c9f712086233f11dbdaf6ca5bd8cf1443e68851a7bd5669e096"
  license "MIT"
  head "https://github.com/mrjackwills/oxker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "854e0f3df43017c01fc533b6b54ec94c67301a60d0358494bc3a19a2c63d7d2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4088515a33e71d6d0f560235bbf6c6fb6adf50c1f260a705517fe925f5481415"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d77cff2dfdcfdfcc4bf11a5f2da1bd835e6a98669474d4eaa1998d407f5bd26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5235ef15b1752a7d913d85e268fc5a77c1ba129095fa6e00932d8569b3074c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "000560f90e7a85f0f0b020916e213b0ca080cccb12e8b68d725fa62bb34c7843"
    sha256 cellar: :any_skip_relocation, ventura:       "d6d0e106e1732dccecf089bd179ed226d30af0046107ed14dbeef903c96d14ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "350b44b8de311a4fd5972c2ffd5c3ac6c4398007972637a44fd4c69b74280812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1df000b14e044fcf3a78a881e3b59a0372cbd30abcd5d3d9fd8ce874e792af35"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxker --version")

    assert_match "a value is required for '--host <HOST>' but none was supplied",
      shell_output("#{bin}/oxker --host 2>&1", 2)
  end
end
