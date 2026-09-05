class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://github.com/1jehuang/jcode/archive/refs/tags/v0.81.7.tar.gz"
  sha256 "05c73fef9ef660f689494f0f8cee630efafb2ed342ab4be64a799d0fe5b7c36c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cd0d010c5168557a129786c8cd637c3f66d10eb3a9379a474286ec7b13a9b85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ee2592edf9e40f96a58f6a2db1b06724904de11fb2fc3d420d6803236c4129a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b54800ab7dc816def1160e4f463a0ab6e97cb6d0a956be2c4fe89e259fbbac2e"
    sha256 cellar: :any,                 arm64_linux:   "872faf4a22934730a6d8803f9c41af43ba04f010edcff7103c344c389159c55e"
    sha256 cellar: :any,                 x86_64_linux:  "f1c86cd8e732e1451fbc3dd54d8107ed751377a1ed4c7083b0b7b7f080d324a3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Disable background auto-update by default
    inreplace "src/cli/args.rs",
              '#[arg(long, global = true, default_value = "true")]',
              '#[arg(long, global = true, default_value = "false")]'

    # Redirect `jcode update` to Homebrew
    inreplace "src/cli/dispatch.rs",
              "hot_exec::run_update()?;",
              'eprintln!("Please update jcode using: brew upgrade jcode");'

    system "cargo", "install", *std_cargo_args
    rm bin/"test_api"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jcode --version")
    assert_match "Please update jcode using: brew upgrade jcode", shell_output("#{bin}/jcode update 2>&1")

    system bin/"jcode-harness", "--cwd", testpath
    assert_match "alpha2", (testpath/"sample.txt").read
  end
end
