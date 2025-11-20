class Megacmd < Formula
  desc "Command-line client for mega.co.nz storage service"
  homepage "https://github.com/t3rm1n4l/megacmd"
  url "https://github.com/t3rm1n4l/megacmd/archive/refs/tags/0.016.tar.gz"
  sha256 "def4cda692860c85529c8de9b0bdb8624a30f57d265f7e70994fc212e5da7e40"
  license "MIT"
  head "https://github.com/t3rm1n4l/megacmd.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "9a2e36bb3c2d380512873dbca8ecac3e42bea9d1007addbce0ca66c3d8114772"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1657b07c1cc68d549882d9d1527671cbf156d3e7f09c42ed3924c20b1c81398e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e45fd178949d3d077930eccf434abb82615d6d237e70262c7f111c92ced0e30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d98cb6158cd237e86b81c5f975cd4d48bf51b67adc3d5b193ebe96b65717823"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f392f9d6d1ba3acece2b86882a1ae6f5f396e37b814460764655d89704e9d5b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0cc423d7d44f74416233d1890e003d8d1a92b32c4f281885e89dbda52031218"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6e1979a101f7e8acb1ace5f72c154c891e0222c4fabbbbb3fdded786c382809"
    sha256 cellar: :any_skip_relocation, ventura:        "59c060122906abf916aeae6cf3732d5d90f316e6bd48af758d91d958f06a7fb2"
    sha256 cellar: :any_skip_relocation, monterey:       "82090686813f52e06f2a9f93c79ea0fc856963575da7d912513a1679ae0b425a"
    sha256 cellar: :any_skip_relocation, big_sur:        "005012522f9d83387047d28fc1f4870b27090496d333a5ace382fd3b2b380850"
    sha256 cellar: :any_skip_relocation, catalina:       "5e3e9a0dcacef7fcac245b621b8eee36cc9dc974b46ba1006769f1dbf781b01c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c84183bc0acc08859d967262e425b7277773716ae9d4a72cec4a52cdda32c5df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9158470703a89b5a963775d8a0470dd3a9e934e8815c1ec171f9574d77fb3c32"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"megacmd", "--version"
  end
end
