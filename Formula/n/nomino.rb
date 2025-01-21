class Nomino < Formula
  desc "Batch rename utility"
  homepage "https://github.com/yaa110/nomino"
  url "https://github.com/yaa110/nomino/archive/refs/tags/1.6.0.tar.gz"
  sha256 "b5e1cf426b19bf859f7098311a47b5917459caf10ef1514282c599fb2bcae18c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yaa110/nomino.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9c863f49f35ecbf66d13d9ed192146fd85e009bac9b6041eae25406024012ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36110b02b2b113e4cdab15c77a502152146fd51c2a24e647faf5a929859552df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab9be5e189c1cbd8e6a2a3f1b4085132d0c3293e1c73321335d6ab25644eeb48"
    sha256 cellar: :any_skip_relocation, sonoma:        "70ded034b35dfd10c2435de06b37e09b4b6e124d7e6b8ae83f01f8a88b9aacd3"
    sha256 cellar: :any_skip_relocation, ventura:       "b9446f6c83dc70436c970969ea41db2ca797b1930d81e5e31bf99ffd2e7660af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4243d252ad89f21f40c82f7d40705f4d019132e0f308e3a7d8e042e79ba9010e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (1..9).each do |n|
      (testpath/"Homebrew-#{n}.txt").write n.to_s
    end

    system bin/"nomino", ".*-(\\d+).*", "{}"

    (1..9).each do |n|
      assert_equal n.to_s, (testpath/"#{n}.txt").read
      refute_predicate testpath/"Homebrew-#{n}.txt", :exist?
    end
  end
end
