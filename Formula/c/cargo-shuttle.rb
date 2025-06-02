class CargoShuttle < Formula
  desc "Build & ship backends without writing any infrastructure files"
  homepage "https://shuttle.dev"
  url "https://github.com/shuttle-hq/shuttle/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "e8a6741ef28375ec2b0839dbe79d8cb7375cd45098e78ca0d28166628df2e795"
  license "Apache-2.0"
  head "https://github.com/shuttle-hq/shuttle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "79302d321300df5809f962361d20e3228b15288545b36573e58267894eb98381"
    sha256 cellar: :any,                 arm64_sonoma:  "959f8db81b4c1b99ddf26974df1653886e75c29ca8058119d36297c04b65b55b"
    sha256 cellar: :any,                 arm64_ventura: "f6761d4a43a1ac123445e2da1563828bf01a51dd6fd10e0c00194c116aa4ada9"
    sha256 cellar: :any,                 sonoma:        "80e738313cc71a9f735589ec32cb2ca47ec4572669b3957663d581a5345d8fe7"
    sha256 cellar: :any,                 ventura:       "6ebb4a19c713ed2c2a2e90dd9a9c7465918f6a8f2301d1777875c70e3c6ea532"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b35e09e5bd2af336faf8543d843442c87ac85065ca994cfbbeac3fe22201af2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7764b21c7a32741098395bb843c5282cf15228ad21541836ecb3f8ba742fe81e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "bzip2"

  conflicts_with "shuttle", because: "both install `shuttle` binaries"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args(path: "cargo-shuttle")

    # cargo-shuttle is for old platform, while shuttle is for new platform
    # see discussion in https://github.com/shuttle-hq/shuttle/pull/1878/#issuecomment-2557487417
    %w[shuttle cargo-shuttle].each do |bin_name|
      generate_completions_from_executable(bin/bin_name, "generate", "shell")
      (man1/"#{bin_name}.1").write Utils.safe_popen_read(bin/bin_name, "generate", "manpage")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shuttle --version")
    assert_match "Unauthorized", shell_output("#{bin}/shuttle account 2>&1", 1)
    output = shell_output("#{bin}/shuttle deployment status 2>&1", 1)
    assert_match "ailed to find a Rust project in this directory.", output
  end
end
