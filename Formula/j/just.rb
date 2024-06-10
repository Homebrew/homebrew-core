class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.28.0.tar.gz"
  sha256 "4c421d1e7b62c41055d53822a44752617ff13aebc76abd6713eb99875c127166"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63c8da7ae1f56b48809260fbc60c526bba2a7f5d8d471e7eb38bf013fe63baf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5311b152596727f5a4bf23cba60df0b3e22a94bdd9ef04c6594c8b8377c0ad28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a9634c72adc07fa1707a0570deb98918dba227f190cf0f2fa0197537f75f41e"
    sha256 cellar: :any_skip_relocation, sonoma:         "98f0a6950471cfd61b953ede69a125622664b87dfd8f3b31c02a67d1e263ac7e"
    sha256 cellar: :any_skip_relocation, ventura:        "9c1f2909710dddadd31b82c7ef70bf082d772ce9e3a76ce080649770356ca978"
    sha256 cellar: :any_skip_relocation, monterey:       "dec21338913dea3c2c545cda8e0254ce4093d6d4de83df8c4e288399bb3960b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63e75657ac8264a144bdbac768cc6a8cfb1932fc450e425c5084239486088366"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"just", "--completions")
    (man1/"just.1").write Utils.safe_popen_read(bin/"just", "--man")
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end
