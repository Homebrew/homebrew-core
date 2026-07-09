class Goreman < Formula
  desc "Foreman clone written in Go"
  homepage "https://github.com/mattn/goreman"
  url "https://github.com/mattn/goreman/archive/refs/tags/v0.3.19.tar.gz"
  sha256 "d5076b8844a4e29815b557927c326d8683ca4a91c8b3ffdad6fd33f238149e43"
  license "MIT"
  head "https://github.com/mattn/goreman.git", branch: "master"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71bcf6a2b0299a437724ae85118480325a6e7be09c4ebfc1f5eea542e1cbf8fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71bcf6a2b0299a437724ae85118480325a6e7be09c4ebfc1f5eea542e1cbf8fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71bcf6a2b0299a437724ae85118480325a6e7be09c4ebfc1f5eea542e1cbf8fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b196f2ca3f59f36b879074b79fd08ba2c7f7f091a2944cafd5bfead3d92f2e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4ef0ceb79b0654307b60efa39bf2cf9b89befb9834e0d8b2e2de3d753bf3676"
    sha256 cellar: :any,                 x86_64_linux:  "e70cdc57c97d96e4f30da4cd7196a17751e5245ae2211c0528976e39c872da02"
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
