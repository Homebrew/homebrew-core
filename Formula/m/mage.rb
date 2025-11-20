class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org"
  url "https://github.com/magefile/mage.git",
      tag:      "v1.15.0",
      revision: "9e91a03eaa438d0d077aca5654c7757141536a60"
  license "Apache-2.0"
  head "https://github.com/magefile/mage.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f47478f5ca2560f1d26a4419dca1894f19220204024bd322d607a7d4d3d301fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d854917c87fca0539be1327468ea017de476cda7744fdd940591cd748fba1b37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d854917c87fca0539be1327468ea017de476cda7744fdd940591cd748fba1b37"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d854917c87fca0539be1327468ea017de476cda7744fdd940591cd748fba1b37"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8fea11b3b195466ee1a8977b4cf79e03076bf44ea18bb90f227025859fe639b"
    sha256 cellar: :any_skip_relocation, ventura:       "c8fea11b3b195466ee1a8977b4cf79e03076bf44ea18bb90f227025859fe639b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e6b55c77f8da7119b98edf75d7ac96b38929f785a87d04bc045a7c3b50d9fe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e003ef001493785054e1e95b8746f6503a28e66a431028fcd751d070139637a"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.com/magefile/mage/mage.timestamp=#{time.iso8601}
      -X github.com/magefile/mage/mage.commitHash=#{Utils.git_short_head}
      -X github.com/magefile/mage/mage.gitTag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "magefile.go created", shell_output("#{bin}/mage -init 2>&1")
    assert_path_exists testpath/"magefile.go"
  end
end
