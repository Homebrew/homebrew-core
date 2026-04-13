class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.32.3.tar.gz"
  sha256 "07aecc63913ce253d6c974fe7fcf9599a9857b9aa8764b0a60dba630beaeb924"
  license "MIT"
  head "https://github.com/Azure/azure-storage-azcopy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6595d3dd56a6b6f4078e385f868c40a6a30c41c9b73cea2693cf790e6ae9226a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26fb8bf779259b3697c2dc10defff9eeba5d36f2d246fd2a7040b28566155396"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af077d37b33af3986facd827926c8a323431a7835a4abe57db174c641be981da"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5c9c1f7760e1715ade9e48e7fd260ddf7430faf919857eabc4002b260612668"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3456c0f712f1b8a9ca9ce2e9fbc46557cbd1cbabf2afe39a099e626da3bbd8ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b6aa208b2711a56e45ce91c665a3e23a16603ed4a62b9fe7adab205b4b5dda9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"azcopy", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Existing Jobs", shell_output("#{bin}/azcopy jobs list")
    assert_match version.to_s, shell_output("#{bin}/azcopy --version")
  end
end
