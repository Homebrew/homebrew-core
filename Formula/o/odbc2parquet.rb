class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https://github.com/pacman82/odbc2parquet"
  url "https://github.com/pacman82/odbc2parquet/archive/refs/tags/v8.1.0.tar.gz"
  sha256 "8cb514b63d114c3a1261370ada09ac4bcd08a717c701dbf631f1a609c19604bb"
  license "MIT"
  head "https://github.com/pacman82/odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ed5f553065f5362939befc7ba36b8ea34e84a711f823e372b7b30cc2520717b1"
    sha256 cellar: :any,                 arm64_sonoma:  "9afda7f375da2878916fabe2047cbf21e18835f6f4703c6dd9aeb4e7ac6543ff"
    sha256 cellar: :any,                 arm64_ventura: "3d078dee8946498c23f853a6608cd14e51f8d10ee7f7c337b2589876719594dc"
    sha256 cellar: :any,                 sonoma:        "3c76916449998c19aeaec035d9a04b46ff5e0bb318cf2c952d0773825fabf915"
    sha256 cellar: :any,                 ventura:       "cc7835f789a89926cbc43e36155973c24f78d095770aade1c38e29a65fb28f80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a07bdbd58484a84659ac9f40c1eed3e834ae795ec2a3b20129681ca27723986d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "940333815e21d2e34433d9293f389dee8b7708c30ed2ccf68a5cbfcc3a4d8d9c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "unixodbc"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/odbc2parquet --version")

    system bin/"odbc2parquet", "list-data-sources"
    system bin/"odbc2parquet", "list-drivers"
  end
end
