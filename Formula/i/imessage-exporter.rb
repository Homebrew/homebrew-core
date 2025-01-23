class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/2.3.0.tar.gz"
  sha256 "b4e4b27b48bda00a0d30af3dfa1e5df4c7002cc36b379865f0842ab826600f03"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "885867793eb363b75b8eb73a02843ee918318066eb6fe57173296a968385a87f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ba8243fa5760bfd96fb7cdd22b3d7085a18259833d6b8c0e410dec7d0b82d9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79770f48f4e8c92e772f632af1e2118db3164c665d58722af0112ac99eec523b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c97c8e5602e47fc2366bd23b66befcb22c4d692d375f04335b6e55f72752523b"
    sha256 cellar: :any_skip_relocation, ventura:       "713f14d44bf9ce89c884ffaa354bdf33f0e4c524b0725531a2dd6001b46abbbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4b218b39b27315c11e3b7a3366c13681b552d299c59501db0cea6b48ed17911"
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
