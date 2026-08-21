class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://nickel-lang.org/"
  url "https://github.com/nickel-lang/nickel/archive/refs/tags/1.17.0.tar.gz"
  sha256 "8cc47b3a2b9ed4e3b7fca06f36a8a295d231e9f8bb112d0cc02081583c189f75"
  license "MIT"
  head "https://github.com/nickel-lang/nickel.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6875ae526b5317e5b824da193b518278f173c1bf8ba761c80dd05b687fc0829e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "186bbfe02ec83530416cfa0ab6118e6106678f0fb18df3e0c39375b12627ec41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c31aac65bfb49ae35b3452131d08ab16e27d8ba904a28591cd1747f9ba62b8d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ffa5283e6d0edc08f154866d860dec2241944e5c21fa1de636727783f7a05c7"
    sha256 cellar: :any,                 arm64_linux:   "14d154463145a173970c3b3273a10425007ca4c3bd47f10859ce27f0dc98b2e2"
    sha256 cellar: :any,                 x86_64_linux:  "579f29d30bdbf86bc9a327cdd08234baad151a8a0389addc246a56194e5b94d3"
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
