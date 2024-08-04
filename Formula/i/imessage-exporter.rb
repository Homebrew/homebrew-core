class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/2.0.1.tar.gz"
  sha256 "44b31f41a5b1397e252f7a62e887f7c0fe9a26e481bfe2474747650776067974"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6525eb9788300f1c26f1b86dad9322f46cbdb15b856a2c8eb4941af964cf4242"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1617a9e265102f4dc49a8a645d05b91a918305596db7bb5d10ae416dfdfbdbf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b10c1f865f071ebd6feabe2b769556345a7114e38956a1d8e475382bb6fa9db"
    sha256 cellar: :any_skip_relocation, sonoma:         "3de134831148ae0f7b3190e25287653f9ac6bf3813d133d5a39ba8b8f46f54c0"
    sha256 cellar: :any_skip_relocation, ventura:        "46d9adcc731017c28002f88af049d628b5e963f22dc81a4f3db319d25bf39daa"
    sha256 cellar: :any_skip_relocation, monterey:       "eb42f1fcd7fede1a1511ba7efc750689b5ae4e3c28517bea2b8a2bb4b51f7276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "690b4b7f094f3f1e96dbf5f999df601905ffcfdd3f6f7e5a42e6cf98613d38eb"
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
