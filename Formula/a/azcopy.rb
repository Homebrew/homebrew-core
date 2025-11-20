class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.31.0.tar.gz"
  sha256 "21ca550d42bb06807d985a5ac003c0b479d55cf15506e948c78a419b421eb5c4"
  license "MIT"
  head "https://github.com/Azure/azure-storage-azcopy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ea9c8def369e8f97c32d4641ed6a78dab61122a6335fdc6242aff5ca73b4b85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "223df44e2cbea3cd51ca1bf12643dd0df85dcc66a56921c32aeeb379fb1fde01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e59532db8e96d7dd12b5715c143ee24e8d92d35b368a101e5ecaf4e9ef50bda"
    sha256 cellar: :any_skip_relocation, sonoma:        "0038eabb1d3b8d67aed7632d96c9dd23b2e19df31baa5be83442d78ae9591d19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a888cbc20cc9a9fdcf6cd1bf6be28109e1e12a164fd41fe98149f2f8edb1947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20ba89af84dc06563e074cb20c4c75d44a68587fe53a88671cf0aa2b6332c1f2"
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
