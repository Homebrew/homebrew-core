class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://github.com/kevinburke/go-bindata/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "ac343c4b316b234b8ea354d86eb3c7ded2da4fe8f40d45f60391d289c66cd950"
  license "BSD-2-Clause"
  head "https://github.com/kevinburke/go-bindata.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b8be1fb86c897d65b0b6697108ef7c1ebe6c6fc775e560d5a912b995fc64b6d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1f977a8bca6e460e124842d67240dbc2001b9fc0fd5fbb4399918609d17503dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e84dc7d2a78aad296659dbe0d476a943eccf5493274e4c0ca6a75470b3c4beaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76617a44d91e752b9bd01f180ae617a0ae71d8109c376162a0a7c7b5a830f135"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76617a44d91e752b9bd01f180ae617a0ae71d8109c376162a0a7c7b5a830f135"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76617a44d91e752b9bd01f180ae617a0ae71d8109c376162a0a7c7b5a830f135"
    sha256 cellar: :any_skip_relocation, sonoma:         "3546c1b7bb0397e9f8fde3eaee97b5c89a6fc0a7519dc45d718d6ed68a5d8916"
    sha256 cellar: :any_skip_relocation, ventura:        "e5e4f74424a4bc23bdba3c3bd8b74031b8b7c1c3ebcd46cfec1fdca526fbd1b4"
    sha256 cellar: :any_skip_relocation, monterey:       "e5e4f74424a4bc23bdba3c3bd8b74031b8b7c1c3ebcd46cfec1fdca526fbd1b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5e4f74424a4bc23bdba3c3bd8b74031b8b7c1c3ebcd46cfec1fdca526fbd1b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ed6a27aace940fd9da6a3d92f175bee2c085cfc25497cf7367403998fafc1818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc06d08b284da8bc9425c70ed2b7d8463799f0ec962c15904a8bb6a84b9eef18"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./go-bindata"
  end

  test do
    (testpath/"data").write "hello world"
    system bin/"go-bindata", "-o", "data.go", "data"
    assert_path_exists testpath/"data.go"
    assert_match '\xff\xff\x85\x11\x4a', (testpath/"data.go").read
  end
end
