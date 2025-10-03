class CargoShuttle < Formula
  desc "Build & ship backends without writing any infrastructure files"
  homepage "https://shuttle.dev"
  url "https://github.com/shuttle-hq/shuttle/archive/refs/tags/v0.57.3.tar.gz"
  sha256 "f6726ccc4e0885d76b55751a252570459ac8a6a42503c6c1e09ed2b2aea44412"
  license "Apache-2.0"
  head "https://github.com/shuttle-hq/shuttle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "53893034e05f07ba1cbe232d50113a1a05d9a5b94e6cc0726cfa59442c643a4b"
    sha256 cellar: :any,                 arm64_sequoia: "c14bb2636101ce21da96496b34b948ea128387f28f87b5c33a02c7f7d61065b0"
    sha256 cellar: :any,                 arm64_sonoma:  "f348b0f5d6241bff629bc68e2bb802f18cc94abf4fed1256249e7da0575ac771"
    sha256 cellar: :any,                 sonoma:        "8e2dbea2a2da19ede37d07cbfad0cf727a59d4f9be669268978d5c16c357a08e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9aa6585bc4a09118827047e8ccbc07cae53f48f35236e0dd8837a0d1931881e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32ed2953148966df0689a01238a4b1122337cafbc037f4bbaf26798d27084ff8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "bzip2"

  conflicts_with "shuttle-cli", because: "both install `shuttle` binaries"

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
    assert_match "Failed to find a Rust project", output
  end
end
