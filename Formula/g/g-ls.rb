class GLs < Formula
  desc "Powerful and cross-platform ls"
  homepage "https://g.equationzhao.space"
  url "https://github.com/Equationzhao/g/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "d0f86bf45ecbaa12d6f3e5cf73686081025c4adfd6251792e751a85f203bcf2f"
  license "MIT"
  head "https://github.com/Equationzhao/g.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b48b96eebd4382160278038cb68d52604b022aa9389fe086d81d175942ca4b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bfb07f1819e14f972d2c9002af374b879c1ce265dd1eec19d39912596f3bc0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0f7f5bc81b94380a54e3aac154fbf1dc661f9013d95eb148219af38ce787dce"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ab7ed42d76c8fb160461f419191f07172935e2cac162d5333866078f04c96c1"
    sha256 cellar: :any_skip_relocation, ventura:        "ecffb21c23042defcbb1ef83f9a7d2f63a5a11c033d17abb0e79201aa0359eea"
    sha256 cellar: :any_skip_relocation, monterey:       "b9ca1bc8afed7e4e3a2a9692df503ce8f1566971ccd5c47144aad49541c7555b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d01081e2128e48c9e6d8ebfe7397ad06d05a268bc0e6d543dbe73a05d9a486f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"g", ldflags: "-s -w")

    man1.install buildpath.glob("man/*.1.gz")
    zsh_completion.install "completions/zsh/_g"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/g -v")
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/g --no-config --hyperlink=never --color=never --no-icon .")
  end
end
