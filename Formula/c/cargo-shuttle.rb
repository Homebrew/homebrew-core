class CargoShuttle < Formula
  desc "Build & ship backends without writing any infrastructure files"
  homepage "https://shuttle.dev"
  url "https://github.com/shuttle-hq/shuttle/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "d377bb0b1c5a6ef01ca0b9eefc9af9549a24d90432a49c9486b431074dcf22f9"
  license "Apache-2.0"
  head "https://github.com/shuttle-hq/shuttle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "40d6c1311bb10e90fb63e62707ca05cffc47f5f8d988bd7d898311f36060aaa8"
    sha256 cellar: :any,                 arm64_sonoma:  "2d89732b61e8c13241bc736157fb10be4c3353c20872aeec4cf3b4644d093132"
    sha256 cellar: :any,                 arm64_ventura: "dc0882b4b49050261981124800e69fb09084776994d7d46ac59ac952a0a38b4f"
    sha256 cellar: :any,                 sonoma:        "a2f5fe4496558e65b44dd3a3180bac9bd35a70e5f43f7cb311611d55571b235d"
    sha256 cellar: :any,                 ventura:       "2482a66dc4b433ed7fb5759ec5514c5c9977568484de5adfa94a3e9a6b74ffb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f18c5fd476c42a8395f9b0a565273338dc90fa4191d1416984abec0df598ef7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "bzip2"

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
    assert_match "Forbidden", shell_output("#{bin}/shuttle account 2>&1", 1)
    assert_match "Error: failed to get cargo metadata", shell_output("#{bin}/shuttle deployment status 2>&1", 1)
  end
end
