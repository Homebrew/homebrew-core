class Bender < Formula
  desc "Dependency management tool for hardware projects"
  homepage "https://github.com/pulp-platform/bender"
  url "https://github.com/pulp-platform/bender/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "7b03dc86a8dcd43b278f84758af287eeb3194bdb707f30ddf9f879e05ab10b7c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/pulp-platform/bender.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65085211d2ab9229701cdd216eb917708b6963f98d3301acecb9d51674d257a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f59c1b0625267c5526dd6cb5ae13eb0fa1e05bf5bdcdc8a48d4470ffe4b4f61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9d3d2c7818fea85741ddab32f1b15b2dcca2cb013a0d5200c8c5e77ce707516"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1d60f88ea984716d828cdb133c94209a9e805526a25b92a3842ba91e4da23b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0aeee5275f1ff86d5b488ec25ff0bc1af62573ffc87813ab88429c5d75dd77bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9488f4a1f1321757d1ef2e1b4ff00194b00898d40049a5580191f2665aa5c54c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"bender", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bender --version")

    system bin/"bender", "init"
    assert_match "manifest format `Bender.yml`", (testpath/"Bender.yml").read
  end
end
