class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://nickel-lang.org/"
  url "https://github.com/tweag/nickel/archive/refs/tags/1.13.0.tar.gz"
  sha256 "677a8400dc0cd86c1ec473423a169550104305667f2e5e9fe4a4a25d8f7d4973"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88ac5ae9d2ad3f5c24138fc0985758785d77645fed24517ca969c60d28035625"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a00e9e463c14af0011e8b90bd5b80b8e60729c244fe7c0a3e301d293a06c7d91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fbba9c42fe6e6caf7cc28a008f0f320d1e25c0cfaa5ce8cf2ac745c2c94fd3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "611bf1ec5fcc7f57062cc2498ad155f8749d0549c72aa9977db840feb10db255"
    sha256 cellar: :any_skip_relocation, sonoma:        "227d5b9f86aa28df59b5bb4ffe9d335937f949717020c16f3aee52f070f595a9"
    sha256 cellar: :any_skip_relocation, ventura:       "dd54954e81e01ff9dc20bb0c5a91a513c8338b5c7213a6a836e4fbbcf0d82b23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8c294b964e5bc5c434c3b356507d165d0b0e7bf3c992bbfec531b10f36fe291"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b20785090dd649e858128bb99f22395dfa64c40463d022170bef0ae4bdd941c"
  end

  depends_on "rust" => :build

  def install
    ENV["NICKEL_NIX_BUILD_REV"] = tap.user.to_s

    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"nickel", "gen-completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nickel --version")

    (testpath/"program.ncl").write <<~NICKEL
      let s = "world" in "Hello, " ++ s
    NICKEL

    output = shell_output("#{bin}/nickel eval program.ncl")
    assert_match "Hello, world", output
  end
end
