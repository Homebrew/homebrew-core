class Fileql < Formula
  desc "Run SQL-like query on local files instead of database files using the GitQL SDK"
  homepage "https://github.com/AmrDeveloper/FileQL"
  url "https://github.com/AmrDeveloper/FileQL/archive/refs/tags/0.10.0.tar.gz"
  sha256 "c85976ffd14454be0f3f973d6d97621f10d8dc0d4814448bd66d2a376f6dfdc2"
  license "MIT"
  head "https://github.com/AmrDeveloper/FileQL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a39972a32477bcc13c803f2d6dfe5e3c82f9f2cff43e0c82395d5cf38464400"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "396ae437cffbace021b760b42ed66c39e78a15edcc82be54a444517922cb7dfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4161567f1ab380b7a69cbc9528c54a1959eec0c77c09b1563f6bc0fc75172ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26b7e5b7d36985905e3c637de9e1a3fec9162cdd948894b99f16e1c8d295c615"
    sha256 cellar: :any_skip_relocation, sonoma:        "d86657e76e6854b5a4924936988f6f7ab2d46346a8409d6c44341acb37f27c1e"
    sha256 cellar: :any_skip_relocation, ventura:       "7608a695e3020c871be877d0e5084605a8f2afa3b405232b11fd8a386c063270"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82e6b09d1c4aae5fd9342910eb5551830a8cfd4b00998cc78f775d22c147c82e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cea79c715f434f14436ebe2cebb5d7ede2f5c2576a6956c18df1c5a0c25426b5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = JSON.parse(shell_output("#{bin}/fileql -o json -q 'SELECT (1 * 2) AS result'"))
    assert_equal "2", output.first["result"]
  end
end
