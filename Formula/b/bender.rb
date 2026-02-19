class Bender < Formula
  desc "Dependency management tool for hardware projects"
  homepage "https://github.com/pulp-platform/bender"
  url "https://github.com/pulp-platform/bender/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "cabfdbf0fb7282986f1c6adc82587cc70095bbb2a93f8f1dce4d6ed2c47c8470"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/pulp-platform/bender.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ddae8775a5202d5acc255d528e717166de1c36f80040e5522593a24849de756"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebc2e044386ee8b4e497d53a340c5a6397409b6238e083d9a312dd4117fc2d7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9336cf5ea1f3577717dbc742759b3c1ff16e1d7c2478a715a2efbd71234edd89"
    sha256 cellar: :any_skip_relocation, sonoma:        "80ea1b27c303c42a27a66d1bba02fd6d92efc0e03d2671faf4772af2b1309f24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cea136581b5a725c19d09660df1e6ca56f88d9da6a4a9c836102c7a63d19192e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ec8cd1d821cd400726bbc84c4acfd4db2bd2e17f0b482952658ada3466b8bfe"
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
