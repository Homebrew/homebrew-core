class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/1.9.0.tar.gz"
  sha256 "2b013db1355a8bd3d7cb7705b1e0da161f4f0a8a9a9076ba072f3adc936e4439"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7f8e15bf559ca3167a3f132f042e9fba14f17ad891594e90558dd9a2a23d190"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e4a20750fa3a00b459cfae3faa8c1550131c99d14dfd7e375822d92864c3294"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7581472a08e6b91b6eb7170c9b008797baa3c0972fe34c40836b02f7a24aa707"
    sha256 cellar: :any_skip_relocation, sonoma:         "56802efeaca8b65941c1208e516de55c69acc34cfc39540dcc34cde6a9786b79"
    sha256 cellar: :any_skip_relocation, ventura:        "40ca1e3a19e87eddf703418bfddcd5e089498904a94963e84107e74827392385"
    sha256 cellar: :any_skip_relocation, monterey:       "d83b9af25cba89e8774267720a3d29fdd3f49be84dec39ec7ba2568456bbdad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ae671e123050d68cdef7aceb65a2632cef5cd4fe41b20f33fa6737e547024af"
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
