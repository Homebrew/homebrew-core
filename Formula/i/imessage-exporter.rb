class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/2.6.1.tar.gz"
  sha256 "e2b6e4d16953ce3c44c4c10a17a0bb73fa7a12ddca80b8fbe1f21f02c7ed5f48"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bcb0b4e4a9be46ecd2c871759d954a8ff5fcceb60bb67fcc4bad9dc50b8ef25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6f9a90d95c4f14010ea287a353a3393e7fed2015619b382657c489df7b3c565"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43cb02bd5e66ebc2f1cdf8fc095fa3607c68f55dbfb44d86961eb7c8d19d1283"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ecaa8842f364f122673085d638eb114c2a11f1e014e0b0ba6f577f19a3a65cf"
    sha256 cellar: :any_skip_relocation, ventura:       "d5403c4656e02bf243278f2fe823902027a30658fe5d61ea45315d12c9134124"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7faa3c346c945d0b48923c444e2c1b3c50d51b761a3e84c8c39137cc7818d9e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09233965a834de6df03fb5b2a22b3caa7be11cd65c252f64e47d0196fa900229"
  end

  depends_on "rust" => :build

  def install
    # manifest set to 0.0.0 for some reason, matching upstream build behavior
    # https://github.com/ReagentX/imessage-exporter/blob/develop/build.sh
    inreplace "imessage-exporter/Cargo.toml", "version = \"0.0.0\"",
                                              "version = \"#{version}\""
    system "cargo", "install", *std_cargo_args(path: "imessage-exporter")
  end

  test do
    assert_match version.to_s, shell_output(bin/"imessage-exporter --version")
    output = shell_output(bin/"imessage-exporter --diagnostics 2>&1")
    assert_match "Invalid configuration: Database not found", output
  end
end
