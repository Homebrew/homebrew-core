class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.29.0.tar.gz"
  sha256 "a42daadd5aaf24303113b5cf62b57271f813575a14ec5bb19e39ddbaf767c429"
  license "MIT"
  head "https://github.com/Azure/azure-storage-azcopy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de23aa2f05916e80a52b7fde3e359d48d481c734efad4cc9b76d916342b8b84f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c5898e3ffd03628c174f0e719eb11c8ed1d01762eedc954a51a27ac2e705713"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "329c99acdbd95391135b2f360194d7005d78e09fa1c42a6f7575538cedc2fecd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6af842aada5e4e3ca49384e99eae0b08d685cbda89d99909d221a0ffac00926"
    sha256 cellar: :any_skip_relocation, ventura:       "0dc9b44c5ca981b2ce93905bbfcf84c437feb39b3e43e3360d4a1345b9a5e989"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8960e06231bda0735b59bcda9a65b6386b2e916d4fe0e1cfb1c51e96049f5a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdc7018a7ca23a940a9a0395872d2d382988e4dcd225d746c93d3687e42a66ee"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"azcopy", "completion")
  end

  test do
    assert_match "Existing Jobs", shell_output("#{bin}/azcopy jobs list")
    assert_match version.to_s, shell_output("#{bin}/azcopy --version")
  end
end
