class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://nickel-lang.org/"
  url "https://github.com/tweag/nickel/archive/refs/tags/1.16.0.tar.gz"
  sha256 "32a449ebc4d463dd193eb8ce8aced5324655188095e709a9c0addb7b3ceeaec3"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f316961ea89f7b1a77eb0b41f48309bfa04d44cdb38933ab6c451b8f9f27304d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a789f9851923d7a0af677ddf00efbaa1f514c110e300059abac0778012971c7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dcc83c98279bd606086e798c3c86e62a26c03aaba5f4ab654d866bf1c7fe167"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cc26de79d5d969db534b40647e280b09a593ed2850b361368bc15c11f9a9cd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4784a57659030969606e685be6ae02acb143aa849e8b44c4aaee46756e7355ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "415e3d13763bee6ac4eadc9e3dcb71d15452b9db84ee92c70fd61ddf4d7e186d"
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
