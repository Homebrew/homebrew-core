class Bunster < Formula
  desc "Compile shell scripts to static binaries"
  homepage "https://bunster.netlify.app/"
  url "https://github.com/yassinebenaid/bunster/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "bab301b4365b0937537154afca867ec989cfe3f2d2233fabfbfa245882abaa1e"
  license "BSD-3-Clause"
  head "https://github.com/yassinebenaid/bunster.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "358db3b08f9fabcf962e0342003873fd4c2aa20cad61a6bf41ee2ae61a8b53f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b582d338176ba738133ad00602adf2bc34f43c1ea6f56b6bfda7c65a05474c8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b582d338176ba738133ad00602adf2bc34f43c1ea6f56b6bfda7c65a05474c8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b582d338176ba738133ad00602adf2bc34f43c1ea6f56b6bfda7c65a05474c8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c154f3dafa865c73e98519d29dab24692c12e418a6ef4dbb67d8f5da945634b4"
    sha256 cellar: :any_skip_relocation, ventura:       "c154f3dafa865c73e98519d29dab24692c12e418a6ef4dbb67d8f5da945634b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cafa15d4686916f99ebf6db783521a268f3faf1172c820e5fa22a3f92b2bd56e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a171f3ab3ab56a91691574af1b10aa145a625438e06a9e98e1d075eee9ba02e"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/bunster"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bunster --version")

    (testpath/"test.sh").write <<~SHELL
      #!/bin/bash
      echo "Hello, World!"
    SHELL

    system bin/"bunster", "build", "test.sh", "-o", "test-binary"
    assert_path_exists testpath/"test-binary"
    assert_match "Hello, World!", shell_output("./test-binary")
  end
end
