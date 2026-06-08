class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/4.1.0.tar.gz"
  sha256 "3699d9f8a5e6767412c46acdeb904d9a0ddea812cffcdf5d7fe74a17bb6fabe6"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36c15cf5a311987fa7f5b0616224f1cabbc0f0cd405f6d90b8f426876f9ea8df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50b6ed1b0325c5f0ade3675af87041490a7bfc120f2bc30b5d74336dfa9e86a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a30cbf943e7352aa3b3a4a86031577f471ff31f3a68080ce169d4a2f189e8e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "74fc5f92fe9dbc93f637d1b6872e12170cf5b10a99cbbfe45d2541d5a49b5618"
    sha256 cellar: :any,                 arm64_linux:   "cf6e92bf1480363e6099e88e3c467f3a90b8cc6d8d3c639863337d77028caf84"
    sha256 cellar: :any,                 x86_64_linux:  "4e34805ff5e03e3572706e8cab2645ec552f67449fafdd2ebf05123680b2de2b"
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
    assert_match version.to_s, shell_output("#{bin}/imessage-exporter --version")
    output = shell_output("#{bin}/imessage-exporter --diagnostics 2>&1", 1)
    assert_match "Invalid configuration", output
  end
end
