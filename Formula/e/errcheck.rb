class Errcheck < Formula
  desc "Finds silently ignored errors in Go code"
  homepage "https://github.com/kisielk/errcheck"
  url "https://github.com/kisielk/errcheck/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "d16b7757bf57dea5bbcfce42badd1bbfadd4c112b2da90b4ccaeb81c6c438c1e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eebf1a2df5e0cbfd40864621539bbf42fdce0833739eb268b31c4009a29230df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eebf1a2df5e0cbfd40864621539bbf42fdce0833739eb268b31c4009a29230df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eebf1a2df5e0cbfd40864621539bbf42fdce0833739eb268b31c4009a29230df"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d4d423b262fe8a36d9eeaca8a1b212f98d7bf4f3cca46fd9605810cf5206fe5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b25f2c81557687e35755a4560a5ed50eca5850a87d2ee9c45d3bd868f31ec5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "282aa6fbb39475568cc1da3f28dadc08dc7612405f339e1607ef58883afc7bfa"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args
    pkgshare.install "testdata"
  end

  test do
    system "go", "mod", "init", "brewtest"
    cp_r pkgshare/"testdata/.", testpath
    output = shell_output("#{bin}/errcheck ./...", 1)
    assert_match "main.go:", output
  end
end
