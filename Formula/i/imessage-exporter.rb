class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/2.5.0.tar.gz"
  sha256 "54e2e12a9ae4f69494e2fbb4a10480e13c84dea72415a494c638eeabf59eabad"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "009bcbf6973c1b413c3e32caffe082fcf94ec3db8ddf39c06a4c367ec069931b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf3f2d7254a6af918d8ab781d499a5a289429b076dcbce4469a984ba6492a70f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d63d57c6102fac61156059c310077b1cdd1a531b321437d9254362e34d440699"
    sha256 cellar: :any_skip_relocation, sonoma:        "1286a56915c82ddd3af6a4408ae0eed573dc300c1af823d07540ebcad960a56b"
    sha256 cellar: :any_skip_relocation, ventura:       "c963ef1cae3dff36963c326d4c2aefaee43c552dbc9d7152b53af7e75f18e39c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdfa4c19a6fd50a973d209cff21c74b4146d126ffc634ce841db9ff3adb38927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2330dcf2700d719ddf29b9113bd0639bdbd5f95057f43e894ce2efaf06fb9a68"
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
