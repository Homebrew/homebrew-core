class Gql < Formula
  desc "Git Query language is a SQL like language to perform queries on .git files"
  homepage "https://github.com/AmrDeveloper/GQL"
  url "https://github.com/AmrDeveloper/GQL/archive/refs/tags/0.25.0.tar.gz"
  sha256 "7eb75c9bb49f8b51524155b9c5d64294ac2bcf2b00812e3c39c1dd7e45aaf96e"
  license "MIT"
  head "https://github.com/AmrDeveloper/GQL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "063c8121b04b0e8b629abd3c974ac30d0bbb4e85622c9ba283170dedd59a6b4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "860e2924c7d92d95a892e6787ab64244bf82631805cb16e2c478e442237d4834"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70bad619aa41ab0efc3120491e9d448fa97b84d54d443ffd86190ae5c44ee606"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff73b7252c43bc67c7dff2caf1dcaa078ea89468309670c7d3781cc41bb57381"
    sha256 cellar: :any_skip_relocation, ventura:        "f218eea487e79d7e4a71d0716881753002c73b5a5eada2df0715808718726962"
    sha256 cellar: :any_skip_relocation, monterey:       "edf02ff1f7b07d41f759bc7da46f1c6ccb7ab9bfd419a9193e0820d17dc53103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "903ad2dbff4c4655822ee4733132f0d264a01f2647417a1775e0238f54ff715a"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  conflicts_with "gitql", because: "both install `gitql` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    output = JSON.parse(shell_output("#{bin}/gitql -o json -q 'SELECT 1 + 1 LIMIT 1'"))
    assert_equal "2", output.first["column_1"]
  end
end
