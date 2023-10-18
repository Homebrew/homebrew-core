class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/1.6.0.tar.gz"
  sha256 "f0042062ee2a2a931fab54c4cdb0dccc3ca7a3b34c9220b5cf5a9d6059ddc432"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b8c6a9d22339916c7bae43bd28354db4fb14ec5646e7a19bf883145f97f06b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bc66e7f0573bc397e13fc5c4a417351c7f7dc0eba92dfcc1c8f6c398d7931ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e546e987ab5ef9bd5b48f4c263a80ae3733b2285b5babf3fdc04ab0065971d68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c534953b2b27ddb97d45ae5761107c5e38372711445e0e7ceb89aa9ba3eb812"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3c59d805005cbca4eb968c0125ef699884ddac30af997058630f7fb073fc48b"
    sha256 cellar: :any_skip_relocation, ventura:        "078c0b6ff433b8612e3bcbcf688c20cb65066b34af0c135421c831ddbcdffd66"
    sha256 cellar: :any_skip_relocation, monterey:       "7ac97704445fae10ce8fb1f1f69fb845b7076d38b31b2e455b2fda5367fef409"
    sha256 cellar: :any_skip_relocation, big_sur:        "6db4a1eea1b729fbbb1f2cb45cc28a715222f7118636f4d0ecb189c3e76af587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a56b625cdec4b8e0143fed6cc36d186d880f9a704bd8f2b16f725bc9ca95ef2"
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
    assert_match "Unable to launch", shell_output(bin/"imessage-exporter --diagnostics 2>&1")
  end
end
