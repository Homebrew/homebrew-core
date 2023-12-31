class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https://www.phylum.io"
  url "https://github.com/phylum-dev/cli/archive/refs/tags/v6.0.1.tar.gz"
  sha256 "1734e6a708f5df6445d5659c4cccdec71f49e7a744534a1bb71311f8ac215500"
  license "GPL-3.0-or-later"
  head "https://github.com/phylum-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65cb35fb4951b998c7f0ef333c62cfa36213343ab217a9129cac59472336e9a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8600218edeef177432e86adbcfaa71a6e6e7a072994bd008a87e74885d91beec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69eb550aae3d3e53560a42cb8a586f1359c291d1e4fb20b9aa2f59500867ea8e"
    sha256 cellar: :any_skip_relocation, sonoma:         "872224aa4680ad4ffca19d3fae1ee51981ee1b61597009bb6a50826d1de3282b"
    sha256 cellar: :any_skip_relocation, ventura:        "7e98df61350c8e73690c417ae55eddeaf3bf25540a96f194c777f89c67c931d5"
    sha256 cellar: :any_skip_relocation, monterey:       "42faae8b05cbb517e3b215fbb3c5114a4f7d26977617ab0286a2419c38fdca2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ea1dbbb1ccf6dabda1ebeaa453fb1eaa8beef2e55493d8ef22e759b90f03da4"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/phylum version")

    output = shell_output("#{bin}/phylum extension")
    assert_match "No extensions are currently installed.", output
  end
end
