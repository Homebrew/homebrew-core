class CargoShuttle < Formula
  desc "Build & ship backends without writing any infrastructure files"
  homepage "https://shuttle.dev"
  url "https://github.com/shuttle-hq/shuttle/archive/refs/tags/v0.56.2.tar.gz"
  sha256 "cad0be082c4c9728170405572a2c5a14391869fa4ce26afddcedc018d78c15ed"
  license "Apache-2.0"
  head "https://github.com/shuttle-hq/shuttle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cf067bdc4d3bc541bf36a419770995690a435df3451bacf62744db70e66f250a"
    sha256 cellar: :any,                 arm64_sonoma:  "3442a53f518d167b0132a5b34529f866d366ffa97a4522f61ab94347ae9ee579"
    sha256 cellar: :any,                 arm64_ventura: "76c8d5fb1492c9ff9052503e4b719c1bf6f3d09b464527cff95a58a8e1961f4a"
    sha256 cellar: :any,                 sonoma:        "d203c9be30e439b42964f0a533d18ceeec1a332af5e98bf3ac6cedd10046683a"
    sha256 cellar: :any,                 ventura:       "eb10354a1343706e9c1d960e737ce488d6d37d1af3a2071846bacc5819371411"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4aff7e7843d7ffee5cf3feaecf3611e23611787859e5531a5e4ba749a7aa07a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04ee790adf8ebe4f0d23c836d5bb8f197dc19d3ec652463c22380d2106dd5922"
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
    assert_match "ailed to find a Rust project in this directory.", output
  end
end
