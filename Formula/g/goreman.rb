class Goreman < Formula
  desc "Foreman clone written in Go"
  homepage "https://github.com/mattn/goreman"
  url "https://github.com/mattn/goreman/archive/refs/tags/v0.3.16.tar.gz"
  sha256 "cdea04dc48ff8a7c44c30b68260203126e0b2ff4de780f5b89867a2c6c5ff7a4"
  license "MIT"
  head "https://github.com/mattn/goreman.git", branch: "master"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c7ccc7361fe05b45a29a2aa2c70c1a9a22e226ecbd20bc80c9363733fca3f0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbb40f361d8ddd7292c0ce9151d7bd4eebb8760ad345f7a1ab16fd22358963ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbb40f361d8ddd7292c0ce9151d7bd4eebb8760ad345f7a1ab16fd22358963ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bbb40f361d8ddd7292c0ce9151d7bd4eebb8760ad345f7a1ab16fd22358963ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "30922c5420a9a47be96ee22712eb3538916de8d49e086d8030a0db7622e32819"
    sha256 cellar: :any_skip_relocation, ventura:       "30922c5420a9a47be96ee22712eb3538916de8d49e086d8030a0db7622e32819"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e99d4fd9f35eda6db79460c5c2a3b7f2ba973bf77c72e6997d5a799f92a040e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e214a6fe2efef00e69e55da73ded0439da12585b5bf3fe93e58e091c6b3de99"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"Procfile").write "web: echo 'hello' > goreman-homebrew-test.out"
    system bin/"goreman", "start"
    assert_path_exists testpath/"goreman-homebrew-test.out"
    assert_match "hello", (testpath/"goreman-homebrew-test.out").read
  end
end
