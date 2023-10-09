class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.26.tar.gz"
  sha256 "507d771f4c863bf98dfe1db3500a4c9344e3a35592a6e2ac4183f00a63291feb"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "982f26e2a73cca9090ece47525b3448c1e11815b36c6a990bdccd09098e83994"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "982f26e2a73cca9090ece47525b3448c1e11815b36c6a990bdccd09098e83994"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "982f26e2a73cca9090ece47525b3448c1e11815b36c6a990bdccd09098e83994"
    sha256 cellar: :any_skip_relocation, sonoma:         "c87b99e048838f524e1853de457a5bc18f4dc2141619ad4930f9f36d24f1d19f"
    sha256 cellar: :any_skip_relocation, ventura:        "c87b99e048838f524e1853de457a5bc18f4dc2141619ad4930f9f36d24f1d19f"
    sha256 cellar: :any_skip_relocation, monterey:       "c87b99e048838f524e1853de457a5bc18f4dc2141619ad4930f9f36d24f1d19f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aefd31c7c90e11b14f773b63a42d5651580ce81b9cf19f684ff39c92ee0c123d"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build

  # Temporarily apply patch to not flag new macOS runner names as invalid.
  # Remove for >=1.6.26
  patch do
    url "https://github.com/rhysd/actionlint/commit/3123d5e319d8e7514be096d1762710e4b5d7e5e2.patch?full_index=1"
    sha256 "8770ff3f7b93311a1849a512fdaa1649a0b23ff6dde3e031faaaa9b40f67c423"
  end

  def install
    ldflags = "-s -w -X github.com/rhysd/actionlint.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/actionlint"
    system "ronn", "man/actionlint.1.ronn"
    man1.install "man/actionlint.1"
  end

  test do
    (testpath/"action.yaml").write <<~EOS
      name: Test
      on: push
      jobs:
        test:
          steps:
            - run: actions/checkout@v2
    EOS

    assert_match "\"runs-on\" section is missing in job", shell_output("#{bin}/actionlint #{testpath}/action.yaml", 1)
  end
end
