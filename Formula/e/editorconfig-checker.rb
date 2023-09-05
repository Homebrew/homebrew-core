class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/2.7.1.tar.gz"
  sha256 "3e33229a8c9cb402ce1d4be7bd7ee6119661dd12c69818dfbd579093dec282cd"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f2da6ec5bc30f8e07b94c43dfe88aebc0a8db0508c6fd22cd973799b32f70f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f2da6ec5bc30f8e07b94c43dfe88aebc0a8db0508c6fd22cd973799b32f70f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f2da6ec5bc30f8e07b94c43dfe88aebc0a8db0508c6fd22cd973799b32f70f4"
    sha256 cellar: :any_skip_relocation, ventura:        "56ab3e9553a0794afe932d3e2d2489a306588140537310852f06d3d2f6988bd6"
    sha256 cellar: :any_skip_relocation, monterey:       "56ab3e9553a0794afe932d3e2d2489a306588140537310852f06d3d2f6988bd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "56ab3e9553a0794afe932d3e2d2489a306588140537310852f06d3d2f6988bd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "472ee032e5f54bbce00467356032cd9907dbfad95093b15d083dc3c580bd3823"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/editorconfig-checker/main.go"
  end

  test do
    (testpath/"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin/"editorconfig-checker", testpath/"version.txt"
    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end
