class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm.git",
      tag:      "v1.2.4",
      revision: "82651008921837b2f21113e4604a807c3f68a97c"
  license "Apache-2.0"
  head "https://github.com/openservicemesh/osm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3290438783446cf475bf7eb660b0f83d61bf3b6634e79ed1490ac9961dfd80e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "355b38a1dbff9c3aaa823e43908a3f8f35896ff53b6841be6049a93a27749e6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f9fc9b20e79dbd991464f6226b5d3d06ec6831cb3def39ba96604f7570875fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5eef76b97e7a512dd02b7e29a699cc570b25e7e2f91ee6ea9032cc8d4f4cd197"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbe85ec87c4c92d790300149d14e518f0936ce6170d7fc0bb9594aedd736a013"
    sha256 cellar: :any_skip_relocation, sonoma:         "1312a5fdb310e7a30de633a528b09d80a5db7bc1c2457013bbedc0cadcea28a2"
    sha256 cellar: :any_skip_relocation, ventura:        "986a024863165c46cb4a73f66ea216e40ac1c2c9502dd368a9cf7e8cf5cd4e30"
    sha256 cellar: :any_skip_relocation, monterey:       "f1efcb2f65f52dee57e1b2544694b00201f45bb36dd391c55e807a2f4b71b8f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "88a968fa2368ec0f1729747d0eead01c22a24cecb8689a8bc639a9a1cb22931e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c331213fde50a3f23b9e668571aa173120210ade4b7768e29c17b167584f49a1"
  end

  deprecate! date: "2024-03-10", because: :repo_archived
  disable! date: "2025-03-24", because: :repo_archived

  depends_on "go" => :build
  depends_on "helm" => :build

  def install
    ENV["VERSION"] = "v"+version if build.stable?
    ENV["BUILD_DATE"] = time.strftime("%Y-%m-%d-%H:%M")
    system "make", "build-osm"
    bin.install "bin/osm"

    generate_completions_from_executable(bin/"osm", "completion")
  end

  test do
    assert_match "Error: Could not list namespaces related to osm", shell_output("#{bin}/osm namespace list 2>&1", 1)
    assert_match "Version:\"v#{version}\"", shell_output("#{bin}/osm version 2>&1", 1)
  end
end
