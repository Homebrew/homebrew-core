class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver/archive/refs/tags/v0.0.53.tar.gz"
  sha256 "2e315b6c563a994d8f5b3d2d8e5be629628b1f6dc7e4a82d9ea1a5deb8c81be6"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa204cb888671e3539a34e23a6e162716898d6d6d22270a1601ef704619b8133"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa204cb888671e3539a34e23a6e162716898d6d6d22270a1601ef704619b8133"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa204cb888671e3539a34e23a6e162716898d6d6d22270a1601ef704619b8133"
    sha256 cellar: :any_skip_relocation, sonoma:         "55505af367af6e096647570194bc3120df57fe21d44cf5a131b0c2581af126c9"
    sha256 cellar: :any_skip_relocation, ventura:        "55505af367af6e096647570194bc3120df57fe21d44cf5a131b0c2581af126c9"
    sha256 cellar: :any_skip_relocation, monterey:       "55505af367af6e096647570194bc3120df57fe21d44cf5a131b0c2581af126c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "168b184b34bee84b7ee5d1a992dfd18c3fa5ce072d2c1da0facaa136a5a4f36b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"config.yml").write <<~EOS
      version: 2
      root-markers:
        - ".git/"
      languages:
        python:
          - lint-command: "flake8 --stdin-display-name ${INPUT} -"
            lint-stdin: true
    EOS
    output = shell_output("#{bin}/efm-langserver -c #{testpath/"config.yml"} -d")
    assert_match "version: 2", output
    assert_match "lint-command: flake8 --stdin-display-name ${INPUT} -", output
  end
end
